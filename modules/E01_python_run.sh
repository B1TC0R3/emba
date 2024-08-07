#!/bin/bash
# EMBA - EMBEDDED LINUX ANALYZER
#
# Copyright 2020-2024 Siemens Energy AG
#
# EMBA comes with ABSOLUTELY NO WARRANTY. This is free software, and you are
# welcome to redistribute it under the terms of the GNU General Public License.
# See LICENSE file for usage of this software.
#
# EMBA is licensed under GPLv3
#
# Author(s): Michael Messner, Thomas Gingele
#
# Description:  This is an experimental EMBA module. It is designed to run user-defined python
#               scripts during the analysis.

E01_python_run() {
    module_log_init "${FUNCNAME[0]}"
    module_title "Python Runner"
    pre_module_reporter "${FUNCNAME[0]}"

    local lSCRIPT_DIR="./modules/E01_python_run"
    local lPYTHON_SCRIPT_COUNT=${#PYTHON_SCRIPTS[@]}
    local lPYTHON_BIN=""

    lPYTHON_BIN="$( find . -name python3 | head -n 1 )"
    if [[ ${lPYTHON_BIN} =~ "/python3" ]]; then
        if [[ ${lPYTHON_SCRIPT_COUNT} -gt 0 ]]; then
            print_output "[*] ${lPYTHON_SCRIPT_COUNT} Python script/s queued for execution."

            for lSCRIPT in "${PYTHON_SCRIPTS[@]}"; do
                sub_module_title "${lSCRIPT}"
                print_output "[*] Executing: ${lPYTHON_BIN} ${lSCRIPT_DIR}/${lSCRIPT}.py"
                ${lPYTHON_BIN} "${lSCRIPT_DIR}/${lSCRIPT}.py"
            done

        else
            print_output "[*] No Python scripts queued for execution."
        fi

    else
        print_output "[-] Unable to locate binary file 'python3'. Aborting"
    fi

    sub_module_title "Final results for ${FUNCNAME[0]}"
    module_end_log "${FUNCNAME[0]}" "${#COUNT_FINDINGS[@]}"
}
