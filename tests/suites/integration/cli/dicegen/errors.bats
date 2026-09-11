source ./tests/lib/init.bash

make_input() {
    local roll_count=${1:?missing roll count}

    local word_count=$((RANDOM % 15 + 5))

    diceroll -"$roll_count" -- "$word_count" >"$BATS_TEST_TMPDIR"/input

    printf "%s\n" "$word_count"
}

assert_invalid() {
    local message=${1:?missing message}
    shift

    local stderr
    run --separate-stderr dicegen "$@" "$BATS_TEST_TMPDIR"/input

    assert_failure
    assert_stderr "dicegen: $message"
}

assert_invalid_digits() {
    local roll_count=${1:?missing roll count}
    shift

    local word_count
    word_count=$(make_input "$roll_count")

    local line=$((RANDOM % word_count + 1))
    local column=$((RANDOM % roll_count + 1))

    # Replace a random digit with an invalid one.
    sed -i "${line}s/./9/${column}" -- "$BATS_TEST_TMPDIR"/input

    assert_invalid "line $line must only contain digits between 1 and 6" "$@"
}

assert_too_short() {
    local roll_count=${1:?missing roll count}
    shift

    local word_count
    word_count=$(make_input "$roll_count")

    local line=$((RANDOM % word_count + 1))

    # Make a random line one character too short.
    sed -i "${line}s/.//" -- "$BATS_TEST_TMPDIR"/input

    assert_invalid "line $line must be exactly $roll_count digits" "$@"
}

assert_too_long() {
    local roll_count=${1:?missing roll count}
    shift

    local word_count
    word_count=$(make_input "$roll_count")

    local line=$((RANDOM % word_count + 1))

    # Make a random line one character too long.
    sed -i "${line}s/$/1/" -- "$BATS_TEST_TMPDIR"/input

    assert_invalid "line $line must be exactly $roll_count digits" "$@"
}

@test "dicegen does not accept invalid digits" {
    assert_invalid_digits 5
}

for opt in -5 --long; do
    bats_test_function --description "dicegen does not accept invalid digits with $opt" -- \
        assert_invalid_digits 5 "$opt"
done

for opt in -4 --short; do
    bats_test_function --description "dicegen does not accept invalid digits with $opt" -- \
        assert_invalid_digits 4 "$opt"
done

@test "dicegen does not accept lines that are too short" {
    assert_too_short 5
}

for opt in -5 --long; do
    bats_test_function --description "dicegen does not accept lines that are too short with $opt" -- \
        assert_too_short 5 "$opt"
done

for opt in -4 --short; do
    bats_test_function --description "dicegen does not accept lines that are too short with $opt" -- \
        assert_too_short 4 "$opt"
done

@test "dicegen does not accept lines that are too long" {
    assert_too_long 5
}

for opt in -5 --long; do
    bats_test_function --description "dicegen does not accept lines that are too long with $opt" -- \
        assert_too_long 5 "$opt"
done

for opt in -4 --short; do
    bats_test_function --description "dicegen does not accept lines that are too long with $opt" -- \
        assert_too_long 4 "$opt"
done
