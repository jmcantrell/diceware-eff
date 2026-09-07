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

To install in the default location (`/usr/local`):

    sudo ./scripts/install

To install in a different location:

    PREFIX=/usr ./scripts/prepare
    sudo PREFIX=/usr ./scripts/install

*NOTE*: `./scripts/prepare` mutates files in the working tree. Run it against a
clean checkout. If you need to change `PREFIX`, discard local changes first
(`git checkout .`) and re-run.

To install in a staging location, set `DESTDIR` for the install script:

    DESTDIR=./pkg ./scripts/install

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

## Maintenance

Update the word lists:

    ./script/update

## Testing

The following packages are required to run tests:

- diffutils
- parallel

To run the included tests:

    ./scripts/test

For command line usage:

    ./scripts/test --help

[pkg-aur]: https://aur.archlinux.org/packages/diceware-eff/
[pkg-aur-git]: https://aur.archlinux.org/packages/diceware-eff-git/
[xkcd]: https://xkcd.com/936/
[idea]: https://theworld.com/~reinhold/diceware.html
[wordlists]: https://www.eff.org/dice
