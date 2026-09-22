source ./tests/lib/init.bash

export BATS_TEST_NAME_PREFIX='bin/dicegen '

setup() {
    lib_dir=$BATS_TEST_TMPDIR/lib

    mkdir -p "$lib_dir"

    export DICEWARE_LIB_DIR=$lib_dir
}

assert_help() {
    run -0 dicegen "$@"
    assert_output --regexp ".*Usage:.*"
}

for flag in -h --help; do
    bats_test_function \
        --description "displays help with $flag" -- \
        assert_help "$flag"
done

assert_version() {
    local fake_version="fake version $RANDOM"

    printf "%s\n" "$fake_version" >"$lib_dir"/version

    run -0 dicegen "$@"
    assert_output "$fake_version"
}

for flag in -v --version; do
    bats_test_function \
        --description "prints version with $flag" -- \
        assert_version "$flag"
done

assert_wordlist() {
    local roll_count=${1:?missing roll count}
    shift

    run -0 dicegen "$@"
    assert_output - "$@" <./share/wordlists/roll"$roll_count"
}

assert_short_wordlist() {
    assert_wordlist ./share/wordlists/roll4 "$@"
}

declare -A count_to_name=([4]=short [5]=long)

for list_opt in -l --list; do
    bats_test_function \
        --description "prints the long word list by default" -- \
        assert_wordlist 5 "$list_opt"

    for roll_count in 4 5; do
        for length_opt in -"$roll_count" --"${count_to_name[$roll_count]}"; do
            bats_test_function \
                --description "prints the ${count_to_name[$roll_count]} word list with $list_opt $length_opt" -- \
                assert_wordlist "$roll_count" "$list_opt" "$length_opt"
        done
    done
done

make_input() {
    local roll_count=${1:?missing roll count}
    local word_count=${2:?missing word count}

    for ((i = 0; i < word_count; i++)); do
        shuf -i 1-6 -n "$roll_count" | paste -s -d ''
    done >"$BATS_TEST_TMPDIR"/input
}

assert_invalid_digits() {
    local roll_count=${1:?missing roll count}
    shift

    local word_count=$((RANDOM % 15 + 5))

    make_input "$roll_count" "$word_count"

    local line=$((RANDOM % word_count + 1))
    local column=$((RANDOM % roll_count + 1))

    # Replace a random digit with an invalid one.
    sed -i "${line}s/./9/${column}" -- "$BATS_TEST_TMPDIR"/input

    run -64 --separate-stderr dicegen "$@" -- "$BATS_TEST_TMPDIR"/input
    refute_output
    assert_stderr "dicegen: line $line must only contain digits between 1 and 6"
}

@test "does not accept invalid digits" {
    assert_invalid_digits 5
}

for roll_count in 4 5; do
    for opt in -"$roll_count" --"${count_to_name[$roll_count]}"; do
        bats_test_function \
            --description "does not accept invalid digits with $opt" -- \
            assert_invalid_digits "$roll_count" "$opt"
    done
done

assert_too_short() {
    local roll_count=${1:?missing roll count}
    shift

    local word_count=$((RANDOM % 15 + 5))

    make_input "$roll_count" "$word_count"

    local line=$((RANDOM % word_count + 1))

    # Make a random line one character too short.
    sed -i "${line}s/.//" -- "$BATS_TEST_TMPDIR"/input

    run -64 --separate-stderr dicegen "$@" -- "$BATS_TEST_TMPDIR"/input
    refute_output
    assert_stderr "dicegen: line $line must be exactly $roll_count digits"
}

@test "does not accept lines that are too short" {
    assert_too_short 5
}

for roll_count in 4 5; do
    for opt in -"$roll_count" --"${count_to_name[$roll_count]}"; do
        bats_test_function \
            --description "does not accept lines that are too short with $opt" -- \
            assert_too_short "$roll_count" "$opt"
    done
done

assert_too_long() {
    local roll_count=${1:?missing roll count}
    shift

    local word_count=$((RANDOM % 15 + 5))

    make_input "$roll_count" "$word_count"

    local line=$((RANDOM % word_count + 1))

    # Make a random line one character too long.
    sed -i "${line}s/$/1/" -- "$BATS_TEST_TMPDIR"/input

    run -64 --separate-stderr dicegen "$@" -- "$BATS_TEST_TMPDIR"/input
    refute_output
    assert_stderr "dicegen: line $line must be exactly $roll_count digits"
}

@test "does not accept lines that are too long" {
    assert_too_long 5
}

for roll_count in 4 5; do
    for opt in -"$roll_count" --"${count_to_name[$roll_count]}"; do
        bats_test_function \
            --description "does not accept lines that are too long with $opt" -- \
            assert_too_long "$roll_count" "$opt"
    done
done

assert_generated() {
    local roll_count=${1:?missing roll count}
    shift

    run -0 dicegen "$@"

    local roll
    while read -r roll; do
        grep "^${roll}"$'\t' ./share/wordlists/roll"$roll_count"
    done <"$BATS_TEST_TMPDIR"/input | cut -d $'\t' -f2 | paste -s -d ' ' |
        assert_output -
}

assert_input_stdin() {
    local roll_count=${1:?missing roll count}
    shift

    local word_count=$((RANDOM % 15 + 5))

    make_input "$roll_count" "$word_count"
    assert_generated "$roll_count" "$@" <"$BATS_TEST_TMPDIR"/input
}

@test "uses the long wordlist by default with input from stdin" {
    assert_input_stdin 5
}

for roll_count in 4 5; do
    for opt in -"$roll_count" --"${count_to_name[$roll_count]}"; do
        bats_test_function \
            --description "uses the ${count_to_name[$roll_count]} wordlist with $opt and input from stdin" -- \
            assert_input_stdin "$roll_count" "$opt"
    done
done

assert_input_file() {
    local roll_count=${1:?missing roll count}
    shift

    local word_count=$((RANDOM % 15 + 5))

    make_input "$roll_count" "$word_count"
    assert_generated "$roll_count" "$@" -- "$BATS_TEST_TMPDIR"/input
}

@test "uses the long wordlist by default with input from a file" {
    assert_input_file 5
}

for roll_count in 4 5; do
    for opt in -"$roll_count" --"${count_to_name[$roll_count]}"; do
        bats_test_function \
            --description "uses the ${count_to_name[$roll_count]} wordlist with $opt and input from a file" -- \
            assert_input_file "$roll_count" "$opt"
    done
done
