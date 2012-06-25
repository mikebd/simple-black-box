# $1 http pattern, to be fed to ngrep. something like 'port 80 and host foo'
set_http_probe () {
        local http_pattern="$1" # to be fed to ngrep.  something like 'port 80 and host foo'
        debug "set_http_probe '$http_pattern'"
        sudo ngrep -W byline $http_pattern > $sandbox/sbb-http &
}

# $1 accepted_codes: egrep-compatible expression of http status codes, example: '(200|201)'
assert_all_responses () {
        local accepted_codes="$1" # egrep-compatible expression of http status codes, example: '(200|201)'
        local num_match=$(egrep -c "^HTTP/1\.. $accepted_codes" $sandbox/sbb-http)
        num_all=$(egrep -c "^HTTP/1\.. " $sandbox/sbb-http)
        if [ $num_match -ne $num_all ]; then
                fail "only $num_match $accepted_codes http response status codes, out of $num_all total"
                egrep "^HTTP/1\.. " $sandbox/sbb-http | debug_stream "all http response codes:"
        else
                win "all $num_match http response codes were $accepted_codes"
        fi
}

# $1 http pattern (as specified to set_http_probe)
remove_http_probe () {
        local http_pattern="$1"
        debug "remove_http_probe '$http_pattern'"
        #FIXME https://sourceforge.net/tracker/?func=detail&aid=3537747&group_id=10752&atid=110752
        # should not require root here.
        sudo pkill -f "^ngrep -W byline $http_pattern"
}
