#!/usr/bin/env python3

import argparse
import os
from pathlib import Path

from constants import DST_DIR_PREFIX


def main():
    parser = argparse.ArgumentParser()

    # Main
    parser.add_argument('-n', '--name', action='store', dest='instance_name', required=True, help='Instance Name')

    # Parse arguments
    args = parser.parse_args()

    # Destination folder
    dst_dir = DST_DIR_PREFIX + args.instance_name

    # Check if directory exist
    if os.path.exists(dst_dir):
        # Create single Yaml file
        with open(os.path.join(dst_dir, 'full.yaml'), 'w') as k8s_file:
            for path in Path(dst_dir).rglob('*/*.yaml'):
                k8s_file.write(open(str(path), 'r').read())
                k8s_file.write('\n---\n')
            k8s_file.flush()
            k8s_file.close()
    else:
        print('Folder for provided name does not exist')


# Main
if __name__ == "__main__":
    main()
