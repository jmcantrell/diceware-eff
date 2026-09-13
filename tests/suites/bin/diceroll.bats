source ./tests/lib/init.bash

export BATS_TEST_NAME_PREFIX='diceroll '

setup() {
    lib_dir=$BATS_TEST_TMPDIR/lib

    mkdir -p "$lib_dir"

    export DICEWARE_LIB_DIR=$lib_dir
}

assert_help() {
    run -0 diceroll "$@"
    assert_output --regexp ".*Usage:.*"
}

for flag in -h --help; do
    bats_test_function --description "displays help with $flag" -- \
        assert_help "$flag"
done

assert_version() {
    local version="fake version"
    printf "%s\n" "$version" >"$lib_dir"/version

    run -0 diceroll "$@"
    assert_output "$version"
}

for flag in -v --version; do
    bats_test_function --description "prints version with $flag" -- \
        assert_version "$flag"
done

assert_rolls() {
    local roll_count=${1:?missing roll count}
    shift

    local word_count=$((RANDOM % 15 + 5))

    local output
    run -0 diceroll "$@" -- "$word_count"

    local rolls
    readarray -t rolls <<<"$output"

    assert_equal "${#rolls[@]}" "$word_count"

    local roll
    for roll in "${rolls[@]}"; do
        assert_regex "$roll" "^[1-6]{$roll_count}$"
    done
}

@test "outputs 5 dice rolls by default" {
    assert_rolls 5
}

declare -A long_opts=([4]=short [5]=long)

for roll_count in 4 5; do
    for opt in -"$roll_count" --"${long_opts[$roll_count]}"; do
        bats_test_function --description "outputs $roll_count dice rolls with $opt" -- \
            assert_rolls "$roll_count" "$opt"
    done
done
