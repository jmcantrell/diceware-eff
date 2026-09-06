diceroll(1)

# NAME

diceroll - Simulate a series of dice rolls

# SYNOPSIS

diceroll -h|--help++
diceroll -v|--version++
diceroll [OPTIONS] COUNT

# DESCRIPTION

For maximum security, the dice rolls used to generate passphrases should be
obtained using a physical six-sided dice and input by hand. For whatever reason,
if that's not possible or necessary, this command can be used to simulate dice
rolls.

This command will output lines suitable to be read with `dicegen`.

# OPTIONS

*-5*
	Use the word list requiring five rolls per word (the default)

*-4*
	Use the word list requiring four rolls per word

# ARGUMENTS

*COUNT*
	Specify how many words worth of dice rolls to print.

# SEE ALSO

*dicegen*(1)
