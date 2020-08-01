# PKGBUILD to JSON

## Introduction

This is a bash script that converts Arch Linux PKGBUILD files into a JSON structure, so it can be further processed or displayed.
It supports most PKGBUILD metadata fields, except the following:

## Unsupported Fields

* **Architecture specific** depends, makedepends, checkdepends, optdepends, checksums, etc.
* Parsing package specifications (I.E. separating package name, version specifier and optional reason).
* Parsing code in packaging functions (E.G. prepare, build, check, package, etc).
* Split packages are only partially supported.

## Dependencies

* [jq](https://stedolan.github.io/jq/) - Command-line JSON processor.

## WARNING!

In order to parse PKGBUILD files, this script sources them directly (PKGBUILD files are compliant bash scripts after all).
Because of this, a malicious PKGBUILD could be created that automatically executes code when it is parsed by this tool.
Please insure your PKGBUILDS are not malicious before passing them to this script!

## Issues & Contributing

Please submit bug reports and feature requests using [the Github issue tracker](https://github.com/mcb2003/pkgbuild2json/issues).
If you'd like to submit a pull request to fix a bug, or add support for something in the list of [unsupported fields](#unsupported-fields),
please feel free! It would be appreciated if you open an [issue](https://github.com/mcb2003/pkgbuild2json/issues) or comment on an existing one before starting.

## License


Copyright (C) 2020  Michael Connor Buchan

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
