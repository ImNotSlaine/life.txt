#!/bin/sh

set -e
# Creates main directory if needed
LIFE_DIR="$HOME/life"
mkdir -p "$LIFE_DIR"

# Outputs the version of the program
get_version() {
	echo 'life version 0.0.1'
	exit 1
}

# Outputs some help for the program
get_help() {
	echo -e "life: life [mode] [command] [name]
	\tTake and manage notes in plain text.\n
	\tModes:
		notes: Note mode.
	\tCommands:
	\t  add: Adds a new note.
	\t		-p: Adds a priority to the note (4 by default).
	\t  del: Remove a note.
	\t  read: Reads a note.
	\t  list: List all notes.
	\t		-p: List notes by priority.
	\t		-d: List notes by date."
}

# Notes mode
notes_command() {
	DIR="$LIFE_DIR/notes"
	mkdir -p "$DIR"

	# Adds a note
	add_note() {
		PRIO="4"
		
		# Gets the priority flag
		while getopts "p:" opt; do
			case "$opt" in
				p)
					case $OPTARG in
						''|*[!0-9]*)
							echo "-$opt requires to be a number"
							exit 1
							;;
					esac
					PRIO="$OPTARG"
					;;
				*)
					echo "Use: life notes add -p [N] 'title'"
					exit 1
					;;
			esac
		done
		
		shift $((OPTIND - 1))

		# Starts creeating a note
		if [ -z "$1" ] ; then
			echo "You must enter the title for the note"
			exit 1
		else
			DATE=$(date +%Y-%m-%d-%H-%M)
			SLUG=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
			FILE="$DIR/$SLUG.txt"

			echo "#$PRIO" > $FILE
			echo "$DATE" >> $FILE
			echo "" >> $FILE
			echo "$1" >> $FILE

			"$EDITOR" "$FILE"

			echo "Note '$1' created"
		fi
	}

	list_note() {
		echo ""
		for i in ~/life/notes/* ; do
			head -n +4 "$i" | tail -n +4
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
			echo "Note '$1' edited"
		fi
	}

	delete_note() {
		if [ -z "$1" ] ; then
			echo "Please select the note you want to remove"
			exit 1
		else
			read -p "Are you sure you want to delete $1? (y/n)" -n 1 -r
			echo
			if [[ $REPLY =~ ^[Yy]$ ]]
			then
				SLUG=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
				rm "$DIR"/"$SLUG".txt
			fi
		fi
	}

	case "$1" in
		add) shift ; add_note "$@" ;;
		list) list_note ;;
		read) shift ; read_note "$@" ;;
		edit) shift ; edit_note "$@" ;;
		del) shift ; delete_note "$@" ;;
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
