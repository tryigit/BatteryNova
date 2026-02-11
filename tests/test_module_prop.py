import unittest
import os

class TestModuleProp(unittest.TestCase):
    def test_module_prop_structure(self):
        """Test that module.prop contains all required fields."""
        prop_file = "module.prop"
        required_fields = {
            "id",
            "name",
            "version",
            "versionCode",
            "author",
            "description"
        }

        self.assertTrue(os.path.exists(prop_file), f"{prop_file} does not exist")

        properties = {}
        with open(prop_file, "r") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#"):
                    continue
                if "=" in line:
                    key, value = line.split("=", 1)
                    properties[key.strip()] = value.strip()

        # Check required fields presence
        missing_fields = required_fields - set(properties.keys())
        self.assertFalse(missing_fields, f"Missing required fields: {missing_fields}")

        # Check values are not empty
        for key in required_fields:
            self.assertTrue(properties[key], f"Value for {key} is empty")

        # Check versionCode is an integer
        try:
            int(properties["versionCode"])
        except ValueError:
            self.fail("versionCode must be an integer")

if __name__ == "__main__":
    unittest.main()
