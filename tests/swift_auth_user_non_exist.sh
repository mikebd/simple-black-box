test_pre () {
        ${config_backend}_change_var $config_sandbox swift_user '"system:foobardoesnotexist"'
}
test_while () {
        assert_num_procs "$process_pattern" 0
        assert_listening "$net_listen_addr" 0
}

test_post () {
        test_post_die_at_auth "Trouble connecting to openstack: Error: request unsuccessful, statusCode: 401" 'HTTP/1.1 401 Unauthorized'
        debug_all_errors
}
