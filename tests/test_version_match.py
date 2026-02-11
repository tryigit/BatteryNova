import json
import sys
import os

def get_module_prop_version(filepath="module.prop"):
    props = {}
    if not os.path.exists(filepath):
        print(f"Error: {filepath} not found")
        return None, None

    with open(filepath, 'r') as f:
        for line in f:
            if '=' in line and not line.strip().startswith('#'):
                parts = line.strip().split('=', 1)
                key = parts[0].strip()
                value = parts[1].strip()
                props[key] = value
    return props.get('version'), props.get('versionCode')

def get_update_json_version(filepath="update.json"):
    if not os.path.exists(filepath):
        print(f"Error: {filepath} not found")
        return None, None

    with open(filepath, 'r') as f:
        data = json.load(f)
    return data.get('version'), data.get('versionCode')

def main():
    mod_ver, mod_ver_code = get_module_prop_version()
    upd_ver, upd_ver_code = get_update_json_version()

    print(f"module.prop: version={mod_ver}, versionCode={mod_ver_code}")
    print(f"update.json: version={upd_ver}, versionCode={upd_ver_code}")

    if mod_ver is None or mod_ver_code is None or upd_ver is None or upd_ver_code is None:
        print("Failed to read versions from one or both files.")
        sys.exit(1)

    failed = False

    # Check versionCode
    try:
        if int(mod_ver_code) != int(upd_ver_code):
            print(f"ERROR: versionCode mismatch! module.prop ({mod_ver_code}) != update.json ({upd_ver_code})")
            failed = True
    except (ValueError, TypeError):
         print(f"ERROR: Invalid versionCode format. module.prop ({mod_ver_code}), update.json ({upd_ver_code})")
         failed = True

    # Check version string
    if mod_ver != upd_ver:
         print(f"ERROR: version string mismatch! module.prop ({mod_ver}) != update.json ({upd_ver})")
         failed = True

    if failed:
        sys.exit(1)

    print("Versions match!")

if __name__ == "__main__":
    main()
