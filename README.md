# Diceware Passphrase Generator

Relying on a computer's pseudo-random number generation to generate completely
secure secrets is inadequate. It turns out that the most secure solution can be
had with a six-sided die and a list of words.

I was first introduced to the concept of diceware via [this xkcd comic][xkcd],
although I wasn't aware that the [idea][idea] had been around for quite some
time. I later found that the EFF had created a [revised set of
wordlists][wordlists] with the goal of making the words more memorable and the
passphrases stronger.

## Installation

### Manual

First, prepare the files for installation:

    PREFIX=/usr/local ./scripts/prepare

Then, install files directly to the prefix:

    PREFIX=/usr/local sudo ./scripts/install

Or, install files elsewhere, like a staging location:

    DESTDIR=./pkg PREFIX=/usr/local ./scripts/install

### Arch User Repository

There are two packages available for Arch Linux, available via the AUR:

- [diceware-eff][pkg-aur] (stable, based on the latest tag)
- [diceware-eff-git][pkg-aur-git] (unstable, based on the latest commit)

## Help

For command line usage:

    dicegen --help
    diceroll --help

For detailed information:

    man 1 dicegen
    man 1 diceroll

## Testing

The following packages are required to run tests:

- bats-assert
- bats-file

To run the included tests:

    ./scripts/test

Arguments will be passed on to `bats`:

    ./scripts/test --abort --timing

[pkg-aur]: https://aur.archlinux.org/packages/diceware-eff/
[pkg-aur-git]: https://aur.archlinux.org/packages/diceware-eff-git/
[xkcd]: https://xkcd.com/936/
[idea]: https://theworld.com/~reinhold/diceware.html
[wordlists]: https://www.eff.org/dice
