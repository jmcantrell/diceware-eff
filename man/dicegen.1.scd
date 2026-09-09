dicegen(1)

# NAME

dicegen - Generate a passphrase from dice rolls

# SYNOPSIS

dicegen -h|--help++
dicegen -v|--version++
dicegen [OPTIONS] [FILE]

# DESCRIPTION

Passphrases are generated from a series of six-sided dice rolls. Each line of
input corresponds to a single word of the passphrase. Depending on the wordlist
being used, each line must be a string of either four or five digits. Each digit
must be between 1 and 6 (inclusive), representing the result of a single
six-sided dice roll. Once EOF is reached, the complete space-delimited
passphrase is printed to stdout.

Care is taken to prevent sensitive information from leaking to an outside
observer. By default, input and output are attached to the tty and thus
vulnerable to shoulder surfing. Act accordingly if this is a concern (e.g.
redirect them to a file/process or go somewhere private). To prevent an attacker
from inferring words selected for the passphrase via file-seek timing, the
entire wordlist is read into memory before processing input. Sensitive
information is never passed to any subprocesses. Likewise, error messages
contain no content from input or output.

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
	from stdin.

# SEE ALSO

*diceroll*(1)
