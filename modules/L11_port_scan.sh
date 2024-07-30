L11_port_scan() {
    module_log_init "${FUNCNAME[0]}"
    module_title "Port Scanner"
    pre_module_reporter "${FUNCNAME[0]}"

    module_end_log "${FUNCNAME[0]}" "${#COUNT_FINDINGS[@]}"
}
