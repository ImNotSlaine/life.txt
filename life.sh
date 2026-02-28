#!/bin/sh

set -e

LIFE_DIR="$HOME/life"
mkdir -p "$LIFE_DIR"

# First command
get_version() {
	echo 'life version 0.0'
	exit 1
}

get_help() {
	echo -e "life: life [mode] [command] [name]
	\tTake and manage notes in plain text.\n
	\tModes:
		notes: Note mode.
	\tCommands:
	\t  add: Adds a new note.
	\t  del: Remove a note.
	\t  read: Reads a note.
	\t  list: List all notes."
}

notes_command() {
	DIR="$LIFE_DIR/notes"
	mkdir -p "$DIR"

	add_note() {
		if [ -z "$1" ] ; then
			echo "You must enter the title for the note"
			exit 1
		else
			SLUG=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
			FILE="$DIR/$SLUG.txt"

			echo "$1" > $FILE

			"$EDITOR" "$FILE"
		fi
	}

	list_note() {
		echo ""
		for i in ~/life/notes/* ; do
			head -1 "$i"
		done
	}

	read_note() {
		echo ""
		if [ -z "$1" ] ; then
			echo "Please select the note you want to read, use 'life notes' or 'life notes list' for listing your notes"
			exit 1
		else
			SLUG=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
			cat "$DIR"/"$SLUG".txt
		fi
	}

	case $1 in
		add) shift ; add_note "$@" ;;
		list) list_note ;;
		read) shift ; read_note "$@" ;;
		*) list_note ;;
	esac
}

case "$1" in
	--version) get_version ;;
	-v) get_version ;;
	--help) get_help ;;
	-h) get_help ;;
	notes) shift; notes_command "$@" ;;
	*) get_help ;;
esac
