source ./tests/lib/init.bash

assert_help() {
    run diceroll "$@"
    assert_success
    assert_output --regexp ".*Usage:.*"
}

for flag in -h --help; do
    bats_test_function --description "diceroll displays help with $flag" -- \
        assert_help "$flag"
done
