from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]


class FactorySafetyTests(unittest.TestCase):
    def text(self, relative):
        return (ROOT / relative).read_text()

    def test_storage_secure_defaults(self):
        text = self.text('infra/modules/security.bicep')
        for expected in [
            "allowBlobPublicAccess: false",
            "allowSharedKeyAccess: false",
            "defaultToOAuthAuthentication: true",
            "publicNetworkAccess: 'Disabled'",
            "minimumTlsVersion: 'TLS1_2'",
        ]:
            self.assertIn(expected, text)

    def test_no_expensive_services_in_templates(self):
        corpus = '\n'.join(p.read_text() for p in (ROOT / 'infra').rglob('*.bicep'))
        forbidden = [
            'Microsoft.Network/azureFirewalls',
            'Microsoft.Network/virtualNetworkGateways',
            'Microsoft.ContainerService/managedClusters',
            'Microsoft.Network/applicationGateways',
            'Microsoft.Compute/virtualMachines',
        ]
        for resource_type in forbidden:
            self.assertNotIn(resource_type, corpus)

    def test_budget_and_tags(self):
        text = self.text('infra/subscription/governance.bicep')
        self.assertIn('Microsoft.Consumption/budgets', text)
        self.assertIn('monthlyBudgetUsd int = 15', text)
        self.assertIn("effect: 'audit'", text)

    def test_destructive_script_has_exact_confirmation(self):
        text = self.text('scripts/destroy.sh')
        self.assertIn('CONFIRM_DESTROY', text)
        self.assertIn('!= "$AZURE_RESOURCE_GROUP"', text)

    def test_evidence_does_not_claim_deployment(self):
        readme = self.text('README.md').lower()
        evidence = self.text('evidence/README.md').lower()
        self.assertIn('blocked by tenant recovery', readme)
        self.assertIn('no cloud screenshots', evidence)

    def test_no_obvious_secrets(self):
        inspected_suffixes = {'.md', '.bicep', '.bicepparam', '.tf', '.sh', '.yml'}
        corpus = '\n'.join(
            p.read_text(errors='ignore')
            for p in ROOT.rglob('*')
            if p.is_file()
            and '.git' not in p.parts
            and 'tests' not in p.parts
            and p.suffix in inspected_suffixes
        ).lower()
        markers = ['client' + '_secret=', 'account' + 'key=', '-----begin private ' + 'key-----']
        for marker in markers:
            self.assertNotIn(marker, corpus)


if __name__ == '__main__':
    unittest.main()
