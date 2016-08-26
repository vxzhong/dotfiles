#!/usr/bin/env python3

import subprocess

packages = [
  'autocomplete-python',
  'file-icons',
  'minimap',
  'pigments',
  'linter',
  'language-babel'
]

installedPackage = subprocess.run(
  ['apm', 'list', '-i'], stdout=subprocess.PIPE, universal_newlines=True).stdout

needToInstallPackage = []

for p in packages:
  if p in installedPackage:
    pass
  else:
    needToInstallPackage.append(p)


installCmd = ['apm', 'install']
installCmd.extend(needToInstallPackage)

subprocess.run(installCmd, check=True);
