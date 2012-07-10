# $1 'pgrep -f'-compatible regex
# $2 number of procs that should match the regex
# $3 deciseconds to wait for number of processes to become the right value. for some processes (such as ngrep),
# it takes some time before the right process names show up in the process table. (default: 50)
assert_num_procs () {
        local proc_match="$1"
        local num_procs_match_goal="$2"
        local timeout=${3:-50}
        [ -n "$proc_match" ] || die_error "assert_num_procs() needs a non-zero pgrep-f compatible regex as \$1"
        [[ "$num_procs_match_goal" =~ ^[0-9]+$ ]] || die_error "assert_num_procs() \$2 must be a number! not $num_procs_match_goal"
        [[ $timeout =~ ^[0-9]+$ ]] || die_error "kill_graceful() \$3 must be a number! not $timeout"
        timer=0
        while [ $timer -ne $timeout ]; do
                num_procs_match=$(pgrep -fc "$1")
                if [ $num_procs_match -eq $num_procs_match_goal ]; then
                        win "$num_procs_match running process(es) matching '$proc_match' (after $timer ds)"
                        return
                fi
                sleep 0.1s
                timer=$((timer+1))
        done
        fail "$num_procs_match running process(es) matching '$proc_match' instead of desired $num_procs_match_goal (after $timer ds)"
}
