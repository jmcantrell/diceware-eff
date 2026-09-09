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

*-5*, *--long*
	Simulate five rolls per line of output (the default)

*-4*, *--short*
	Simulate four rolls per line of output

# ARGUMENTS

*COUNT*
	Specify how many words worth of dice rolls to print.

# SEE ALSO

*dicegen*(1)
