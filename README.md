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

### Repository

To install in the default location (`/usr/local`):

    sudo ./scripts/install

To install in a different location:

    sudo PREFIX=/usr ./scripts/install

To install in a staging location:

    DESTDIR=./pkg ./scripts/install

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

[idea]: https://theworld.com/~reinhold/diceware.html
[wordlists]: https://www.eff.org/dice
[xkcd]: https://xkcd.com/936/
