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
    printf "fake version\n" >"$lib_dir"/version

    run -0 dicegen "$@"
    assert_output "fake version"
}

for flag in -v --version; do
    bats_test_function \
        --description "prints version with $flag" -- \
        assert_version "$flag"
done

assert_wordlist() {
    local wordlist=${1:?missing wordlist}
    shift

    run -0 dicegen "$@"
    assert_output - <"$wordlist"
}

assert_long_wordlist() {
    assert_wordlist ./share/wordlists/roll5 "$@"
}

assert_short_wordlist() {
    assert_wordlist ./share/wordlists/roll4 "$@"
}

for list_opt in -l --list; do
    bats_test_function \
        --description "prints the long word list by default" -- \
        assert_long_wordlist "$list_opt"

    for length_opt in -5 --long; do
        bats_test_function \
            --description "prints the long word list with $list_opt $length_opt" -- \
            assert_long_wordlist "$list_opt" "$length_opt"
    done

    for length_opt in -4 --short; do
        bats_test_function \
            --description "prints the short word list with $list_opt $length_opt" -- \
            assert_short_wordlist "$list_opt" "$length_opt"
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

for opt in -5 --long; do
    bats_test_function \
        --description "does not accept invalid digits with $opt" -- \
        assert_invalid_digits 5 "$opt"
done

for opt in -4 --short; do
    bats_test_function \
        --description "does not accept invalid digits with $opt" -- \
        assert_invalid_digits 4 "$opt"
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

for opt in -5 --long; do
    bats_test_function \
        --description "does not accept lines that are too short with $opt" -- \
        assert_too_short 5 "$opt"
done

for opt in -4 --short; do
    bats_test_function \
        --description "does not accept lines that are too short with $opt" -- \
        assert_too_short 4 "$opt"
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

for opt in -5 --long; do
    bats_test_function \
        --description "does not accept lines that are too long with $opt" -- \
        assert_too_long 5 "$opt"
done

for opt in -4 --short; do
    bats_test_function \
        --description "does not accept lines that are too long with $opt" -- \
        assert_too_long 4 "$opt"
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

for opt in -5 --long; do
    bats_test_function \
        --description "uses the long wordlist with $opt and input from stdin" -- \
        assert_input_stdin 5 "$opt"
done

for opt in -4 --short; do
    bats_test_function \
        --description "uses the short wordlist with $opt and input from stdin" -- \
        assert_input_stdin 4 "$opt"
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

for opt in -5 --long; do
    bats_test_function \
        --description "uses the long wordlist with $opt and input from a file" -- \
        assert_input_file 5 "$opt"
done

for opt in -4 --short; do
    bats_test_function \
        --description "uses the short wordlist with $opt and input from a file" -- \
        assert_input_file 4 "$opt"
done
