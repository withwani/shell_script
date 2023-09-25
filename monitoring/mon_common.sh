#!/bin/bash
export LANG=ko_KR.UTF-8

#source stdlib.sh

##### Definitions

# set_log_level INFO


##### Functions

# whether the param is number or not
is_number() {
    v=$1
    r=${v#-}
    r=${v//[0-9]/}

    if [ -z "${r}" ]; then
            echo "int"
    else
            echo "str"
    fi
}

# whether the string includes alive or not
has_alive() {
    v=$1
    if [[ "${v}" =~ "alive" ]]; then
            echo 0
    else
            echo 1
    fi
}

has_alive1() {
    v=$1
    log_debug "has_alive1(), arg: ${v}"
    if [[ "${v}" =~ "alive" ]]; then
            return 0
    else
            return 1
    fi
}

# whether the arg is null or not
is_null() {
    (($#)) || return
    local val=$1
    # null check
    if [ -z $val ]; then
        return 0
    fi
    return
}

# whether the email is in the allowed list
check_email() {
    (($#)) || return
#    local l=$1
#    local e=$2

    local rf=$1
    local em=$2

    log_debug "check_email(), allowed_list=${rf}, email=${em}"

    if [[ ! -f $rf ]]; then
        log_error "File '${rf}' does not exist, skipping this step"
    else
        # log the contents of this file in DEBUG mode
        log_debug_file "$rf"
        rft=$?
        log_debug "${rft[@]}"

        while read line || [ -n "$line" ]; do
            log_debug "$line"
            log_debug "check_email(), ${line} == ${email}"
            if [ ${line} == ${email} ]; then
                log_info "Matching item: ${line}"
                return 0
            fi
        done < $rf
    fi
    log_debug "End of function"
    return 1
}

