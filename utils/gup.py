#! /usr/bin/env python3

# walk directory with .git and do git pull to update source

import sys
import os.path
import subprocess

top = os.path.abspath(sys.argv[1])

for root, dirs, files in os.walk(top):
    if '.git' in dirs:
        dirs.clear()
        print(root)
        os.chdir(root)
        subprocess.run(['git', 'pull'])
