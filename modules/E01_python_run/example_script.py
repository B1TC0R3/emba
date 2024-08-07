#!/usr/bin/python3
# EMBA - EMBEDDED LINUX ANALYZER
#
# Copyright 2024-2024 Siemens Energy AG
#
# EMBA comes with ABSOLUTELY NO WARRANTY. This is free software, and you are
# welcome to redistribute it under the terms of the GNU General Public License.
# See LICENSE file for usage of this software.
#
# EMBA is licensed under GPLv3
# SPDX-License-Identifier: GPL-3.0-only
#
# Author(s): Thomas Gingele
#
# Description: This python script servers as an example to create others. It only echoes passed parameters and then exits.
from sys import argv


def main():
    print("[*] Python script '{argv[0]}' executed successfully.")

    if len(argv) > 1:
        for arg in argv[1:]:
            print(f"[*] Received argument: '{arg}'")

    else:
        print(f"[*] No arguments received.")

    print("[*] Empty python ")


main()
