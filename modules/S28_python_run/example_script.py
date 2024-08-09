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
from os import environ


LOGFILE = None


def example_script(arguments: dict):
    # This method contains the module code
    log("Recvied arguments:")
    for key, value in enumerate(arguments):
        log(f"\t- {key} :: {value}")


def log(text):
    print(text)

    if LOGFILE:
        LOGFILE.writelines(text)


# Module and logging setup. Not intended to be changed.
def setup():
    global LOGFILE
    logfile_dir = environ.get('LOG_PATH_MODULE')
    filename = argv[0].split("/")[-1]
    LOGFILE = open(f"{logfile_dir}/{filename}", "w")

    log(f"[*] Process '{argv[0]}' started.")
    example_script({"argv": argv})

    if LOGFILE:
        LOGFILE.close()

    log(f"[*] Process '{filename}' finished.")


setup()
