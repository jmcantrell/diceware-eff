# Diceware Passphrase Generator

Relying on a computer's pseudo-random number generation to generate completely
secure secrets is inadequate. It turns out that the most secure solution can be
had with a six-sided die and a list of words.

I was first introduced to the concept of diceware via [this xkcd comic][xkcd],
although I wasn't aware that the [idea][idea] had been around for quite some
time. After deciding to get serious about securing my own systems, I found that
the EFF had created a [revised set of wordlists][wordlists] with the goal of
making the words more memorable and the passphrases stronger.

## Installation

Install to your home directory:

    ./scripts/deploy

## Usage

Generate a passphrase from dice rolls:

    dicegen -h

Simulate dice rolls from the system's pseudo-random number generator:

    diceroll -h

Generate a pseudo-random six-word passphrase from five-digit rolls:

    diceroll 5 6 | dicegen 5

Passphrases used to secure sensitive data should **always** be produced using
physical dice rolls.

## Maintenance

Update the word lists:

    ./script/update

[idea]: https://theworld.com/~reinhold/diceware.html
[wordlists]: https://www.eff.org/dice
[xkcd]: https://xkcd.com/936/
