source ./tests/lib/init.bash

assert_output() {
    local roll_count=${1:?missing roll count}
    shift

    local word_count=$((RANDOM % 15 + 5))

    local output
    run diceroll "$@" -- "$word_count"

    assert_success

    local rolls
    readarray -t rolls <<<"$output"

    assert_equal "${#rolls[@]}" "$word_count"

    local i
    for ((i = 0; i < ${#rolls[@]}; i++)); do
        assert_regex "${rolls[i]}" "^[1-6]{$roll_count}$"
    done
}

@test "diceroll outputs 5 dice rolls" {
    assert_output 5
}

declare -A long_opts=([4]=short [5]=long)

for roll_count in 4 5; do
    for opt in -"$roll_count" --"${long_opts[$roll_count]}"; do
        bats_test_function --description "diceroll outputs $roll_count dice rolls with $opt" -- \
            assert_output "$roll_count" "$opt"
    done
done
