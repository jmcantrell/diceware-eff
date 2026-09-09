dicegen(1)

# NAME

dicegen - Generate a passphrase from dice rolls

# SYNOPSIS

dicegen -h|--help++
dicegen -v|--version++
dicegen [OPTIONS] [FILE]

# OPTIONS

*-5*, *--long*
	Use the word list requiring five rolls per word (the default)

*-4*, *--short*
	Use the word list requiring four rolls per word

*-l*, *--list*
	Print the word list instead of generating a passphrase.

# ARGUMENTS

*FILE*
	Read dice rolls from FILE. If no FILE is provided, input will be read
	from stdin. Each input line must be a string of 4 or 5 digits (depending
	on the list used). Each digit represents the result of a single
	six-sided dice roll. Once EOF is reached, the space-delimited passphrase
	is printed to stdout.


# DESCRIPTION

Dice rolls are read from stdin.
Each line of stdin must be a string of digits of length NUMBER.
For example, 12345 would correspond to a five-letter word from the word list.
Once EOF is reached, the complete space-delimited passphrase is printed to stdout.

# SEE ALSO

*diceroll*(1)
