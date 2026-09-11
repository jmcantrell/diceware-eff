source ./tests/lib/init.bash

make_input() {
    local roll_count=${1:?missing roll count}
    shift

    diceroll "$@" -- $((RANDOM % 15 + 5)) >"$BATS_TEST_TMPDIR"/input
}

assert_output() {
    local roll_count=${1:?missing roll count}
    shift

    local output
    run dicegen "$@"
    assert_success

    tr ' ' '\n' <<<"$output" >"$BATS_TEST_TMPDIR"/output

    local roll word
    while read -r roll word; do
        assert_file_contains ./share/wordlists/roll"$roll_count" "^${roll}"$'\t'"${word}$"
    done < <(paste -- "$BATS_TEST_TMPDIR"/{input,output})
}

assert_input_stdin() {
    local roll_count=${1:?missing roll count}
    shift

    make_input "$roll_count" "$@"
    assert_output "$roll_count" "$@" <"$BATS_TEST_TMPDIR"/input
}

@test "dicegen accepts input from stdin" {
    assert_input_stdin 5
}

for opt in -5 --long; do
    bats_test_function --description "dicegen accepts input from stdin with $opt" -- \
        assert_input_stdin 5 "$opt"
done

for opt in -4 --short; do
    bats_test_function --description "dicegen accepts input from stdin with $opt" -- \
        assert_input_stdin 4 "$opt"
done

assert_input_file() {
    local roll_count=${1:?missing roll count}
    shift

    make_input "$roll_count" "$@"
    assert_output "$roll_count" "$@" -- "$BATS_TEST_TMPDIR"/input
}

@test "dicegen accepts input from a file argument" {
    assert_input_file 5
}

for opt in -5 --long; do
    bats_test_function --description "dicegen accepts input from a file argument with $opt" -- \
        assert_input_file 5 "$opt"
done

for opt in -4 --short; do
    bats_test_function --description "dicegen accepts input from a file argument with $opt" -- \
        assert_input_file 4 "$opt"
done
