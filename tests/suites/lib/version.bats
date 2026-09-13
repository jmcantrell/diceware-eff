source ./tests/lib/init.bash

@test "version file is in the expected format" {
    local lines
    readarray -t lines <./lib/version

    assert_equal "${#lines[@]}" 1
    assert_regex "${lines[0]}" "^[0-9.]+$"

    printf "%s\n" "${lines[0]}" >"$BATS_TEST_TMPDIR"/version
    assert_files_equal {"$BATS_TEST_TMPDIR",./lib}/version
}
