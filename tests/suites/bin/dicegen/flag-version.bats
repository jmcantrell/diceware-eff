source ./tests/lib/init.bash

assert_version() {
    local output
    run dicegen "$@"
    printf "%s\n" "$output" >"$BATS_TEST_TMPDIR"/output

    assert_success
    assert_files_equal "$BATS_TEST_TMPDIR"/output ./lib/version
}

for flag in -v --version; do
    bats_test_function --description "dicegen prints version with $flag" -- \
        assert_version "$flag"
done
