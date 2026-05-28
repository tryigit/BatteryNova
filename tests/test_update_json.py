import json
import os
from urllib.parse import urlparse

def is_valid_url(url):
    try:
        result = urlparse(url)
        return all([result.scheme in ['http', 'https'], result.netloc])
    except ValueError:
        return False

def test_update_json():
    # Construct the absolute path to update.json located at the project root
    current_dir = os.path.dirname(os.path.abspath(__file__))
    filepath = os.path.join(current_dir, '..', 'update.json')

    assert os.path.exists(filepath), f"Error: {filepath} not found"

    with open(filepath, 'r') as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError as e:
            assert False, f"Error: Invalid JSON format in {filepath} - {e}"

    required_keys = ["version", "versionCode", "zipUrl", "changelog"]

    for key in required_keys:
        assert key in data, f"ERROR: Missing required key '{key}' in {filepath}"

    assert isinstance(data.get("version"), str), f"ERROR: 'version' must be a string, got {type(data.get('version')).__name__}"

    assert isinstance(data.get("versionCode"), int), f"ERROR: 'versionCode' must be an integer, got {type(data.get('versionCode')).__name__}"

    zip_url = data.get("zipUrl")
    assert is_valid_url(zip_url), f"ERROR: 'zipUrl' is not a valid HTTP/HTTPS URL: {zip_url}"

    changelog_url = data.get("changelog")
    assert is_valid_url(changelog_url), f"ERROR: 'changelog' is not a valid HTTP/HTTPS URL: {changelog_url}"

if __name__ == "__main__":
    # If run directly as a script, execute the test function
    try:
        test_update_json()
        print("update.json validation passed!")
    except AssertionError as e:
        print(f"update.json validation failed: {e}")
        import sys
        sys.exit(1)
