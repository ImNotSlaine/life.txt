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
			DATE=$(date +%d-%m-%Y-%H-%M)
			SLUG=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
			FILE="$DIR/$SLUG.txt"

			echo "$DATE" > $FILE
			echo "" >> $FILE
			echo "$1" >> $FILE

			"$EDITOR" "$FILE"

			echo "Note created"
		fi
	}

	list_note() {
		echo ""
		for i in ~/life/notes/* ; do
			head -n +3 "$i" | tail -n +3
		done
	}

	read_note() {
		echo ""
		if [ -z "$1" ] ; then
			echo "Please select the note you want to read"
			exit 1
		else
			SLUG=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
			tail -n +3 "$DIR"/"$SLUG".txt
		fi
	}

	edit_note() {
		if [ -z "$1" ] ; then
			echo "Please select the note you want to edit"
			exit 1
		else
			SLUG=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
			"$EDITOR" "$DIR"/"$SLUG".txt
		fi
	}

	delete_note() {
		if [ -z "$1" ] ; then
			echo "Please select the note you want to remove"
			exit 1
		else
			SLUG=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
			rm "$DIR"/"$SLUG".txt
		fi
	}

	case $1 in
		add) shift ; add_note "$@" ;;
		list) list_note ;;
		read) shift ; read_note "$@" ;;
		edit) shift ; edit_note "$@" ;;
		remove) shift ; delete_note "$@" ;;
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
