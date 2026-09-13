source ./tests/lib/init.bash

export BATS_TEST_NAME_PREFIX='version '

@test "file is in the expected format" {
    assert_file_contains ./lib/version '^[0-9.]\+$'
}
