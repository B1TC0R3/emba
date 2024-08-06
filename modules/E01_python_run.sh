#!/bin/bash

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
