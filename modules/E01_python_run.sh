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

    local lPYTHON_SCRIPT_COUNT=${#PYTHON_SCRIPTS[@]}

    if [[ ${lPYTHON_SCRIPT_COUNT} -gt 0 ]]; then
        print_output "[*] ${lPYTHON_SCRIPT_COUNT} Python scripts queued for execution."

        for SCRIPT in "${PYTHON_SCRIPTS[@]}"; do
            print_output "[*] Running ${SCRIPT}."
            run_python_script "${SCRIPT}"
        done
    else
        print_output "[*] No Python scripts queued for execution."
    fi

    module_end_log "${FUNCNAME[0]}" "${#COUNT_FINDINGS[@]}"
}

run_python_script() {
    local lFILENAME="${1}.py"
    print_output "[!] Simulated execution of file: ${lFILENAME}"
}
