source ./tests/lib/init.bash

assert_wordlist() {
    local wordlist=${1:?missing wordlist}
    shift

    local output
    run dicegen "$@"
    printf "%s\n" "$output" >"$BATS_TEST_TMPDIR"/output

    assert_success
    assert_files_equal "$BATS_TEST_TMPDIR"/output "$wordlist"
}

assert_long_wordlist() {
    assert_wordlist ./share/wordlists/roll5 "$@"
}

assert_short_wordlist() {
    assert_wordlist ./share/wordlists/roll4 "$@"
}

for list_opt in -l --list; do
    bats_test_function --description "dicegen prints the long word list by default" -- \
        assert_long_wordlist "$list_opt"

    for length_opt in -5 --long; do
        bats_test_function --description "dicegen prints the long word list with $list_opt${length_opt:+ $length_opt}" -- \
            assert_long_wordlist "$list_opt" ${length_opt:+"$length_opt"}
    done

    for length_opt in -4 --short; do
        bats_test_function --description "dicegen prints the short word list with $list_opt $length_opt" -- \
            assert_short_wordlist "$list_opt" "$length_opt"
    done
done
