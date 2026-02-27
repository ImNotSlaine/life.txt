#!/bin/sh

set -e

mode="$1"
command="$2"
name="$3"

LIFE_DIR="$HOME/life"
mkdir -p "$LIFE_DIR"

echo "$0 , $mode , $command" , $name
# First command
get_version() {
	echo 'life version 0.0'
	exit 1
}

get_help() {
	echo -e "life: life [command] [name]
	\tTake and manage notes in plain text.\n
	\tCommands:
	\t  add [name]: adds a new note.
	\t  del [name]: remove a note.
	\t  read [name]: reads a note.
	\t  list: list all notes."
}

notes_command() {
	DIR="$LIFE_DIR/notes"
	mkdir -p "$DIR"

	echo "$command"

	case $command in
		add)
			[ -z "$name" ] && echo "You must enter the title for the new note" 

			DATE=$(date +%d-%m-%Y)
			echo "$DATE"
			SLUG=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
			echo "$SLUG"
			FILE="$DIR/$DATE-$SLUG.txt"
			echo "$FILE"

			echo "Title: $name" > $FILE
			echo
			echo "Date: $DATE"
			echo
			;;
		*)
			echo "No parameter"
			;;
	esac
}

case "$1" in
	--version) get_version ;;
	-v) get_version ;;
	--help) get_help ;;
	-h) get_help ;;
	notes) notes_command ;;
	*) get_help ;;
esac
