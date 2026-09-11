export PATH=$PWD/bin:$PATH

export DICEWARE_LIB_DIR=$PWD/lib
export DICEWARE_DATA_DIR=$PWD/share

bats_require_minimum_version 1.5.0

bats_load_library bats-support
bats_load_library bats-assert
bats_load_library bats-file
