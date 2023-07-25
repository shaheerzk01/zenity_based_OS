#!/bin/bash

# Function of date and time
get_date_time() {
    date +"%A, %B %d, %Y - %H:%M:%S"
}

# Function to handle file deletion
delete_file() {
    local file=$(zenity --file-selection --title="Select a file to delete:")
    if [ -z "$file" ]; then
        zenity --error --text="No file selected. Please try again."
    else
        rm "$file"
        zenity --info --text="File deleted successfully: $file"
    fi
}
# Funtion to handle file creation
create_file() {
    location=$(zenity --file-selection --directory --title="Choose a directory to create the file:")
    if [ -z "$location" ]; then
         zenity --error --text="Invalid location. Please try again."
    else
         filename=$(zenity --entry --title="Create File" --text="Enter the filename:")
              if [ -z "$filename" ]; then
                     zenity --error --text="Invalid filename. Please try again."
              else
                     touch "$location/$filename"
                     zenity --info --text="File created successfully: $location/$filename"
              fi
     fi
}

# Function to handle file rename
rename_file() {
    local file=$(zenity --file-selection --title="Select a file to rename:")
    if [ -z "$file" ]; then
        zenity --error --text="No file selected. Please try again."
    else
        new_name=$(zenity --entry --title="Rename File" --text="Enter the new name for the file:" --entry-text "$(basename "$file")")
        if [ -z "$new_name" ]; then
            zenity --error --text="Invalid new name. Please try again."
        else
            new_file="$(dirname "$file")/$new_name"
            mv "$file" "$new_file"
            zenity --info --text="File renamed successfully:\nOld Name: $file\nNew Name: $new_file"
        fi
    fi
}

# Function for process management
process_management() {
    datetime=$(get_date_time)
    while true; do
        choice=$(zenity --list --title="Process Management" --text="Choose an option:" \
                        --column="Option" \
			--extra-button="Date and Time:$datetime" \
			--width=600 --height=400 \
                        "View Processes" \
                        "Kill Process" \
                        "Exit")
        if [ "$choice" = "extra-button-1" ]; then
            # Display the date and time in a dialog
            zenity --info --text="$datetime" --width=300 --height=100
	else
            case "$choice" in
                 "View Processes")
                      # Display running processes using Zenity dialog
                      processes=$(ps aux)
                      zenity --info --title="Running Processes" --text="$processes"
                      ;;
                 "Kill Process")
                      # Prompt user to enter the PID of the process to kill
                      pid=$(zenity --entry --title="Kill Process" --text="Enter the PID of the process to kill:")
                      if [ -z "$pid" ]; then
                            zenity --error --text="Invalid PID. Please try again."
                      else
                            # Kill the specified process
                            kill "$pid"
                            zenity --info --text="Process with PID $pid killed."
                      fi
                      ;;
                 "Exit")
                      # Return to the main menu
                      return
                      ;;
                 *)
                      zenity --error --text="Invalid choice. Please try again."
                      ;;
            esac
	fi
    done
}

# Function for file explorer
file_explorer() {
    local search_dir="/path/to/search/directory"

    while true; do
        # Display the current directory content using Zenity dialog
        search_dir=$(zenity --file-selection --title="File Explorer" --filename="$search_dir" --directory)

        if [ -z "$search_dir" ]; then
            # No directory selected, return to the main menu
            return
        else
            # Open new terminal with the selected directory as the working directory
            gnome-terminal --working-directory="$search_dir" &
            # Return to the main menu
            return
        fi
    done
}

# Function to open editor
open_editor() {
    datetime=$(get_date_time)
    # Display selection dialog using Zenity
    choice=$(zenity --list --title="Select Text Editor" --text="Choose a text editor:" \
                    --column="Editor" \
		    --extra-button="Date and Time:$datetime" \
		    --width=600 --height=400 \
                    "gedit" \
                    "nano" \
                    "vim")
    if [ "$choice" = "extra-button-1" ]; then
            # Display the date and time in a dialog
            zenity --info --text="$datetime" --width=300 --height=100
    else
            # Check the selected editor and open it
            case "$choice" in
                 "gedit")
                     gedit
                     ;;
                 "nano")
                     nano
                     ;;
                 "vim")
                     vim
                     ;;
                 *)
                     zenity --error --text="Invalid selection. Please try again."
                     ;;
            esac
    fi
}



while true; do
    datetime=$(get_date_time)
    # Display the main menu using Zenity dialog
    choice=$(zenity --list --title="MyShell OS" --text="Choose an option:" \
                    --column="Option" \
		    --extra-button="Date and Time:$datetime" \
	            --width=600 --height=400 \
                    --hide-header \
		    "File Explorer" \
		    "Sudoku" \
                    "Terminal" \
		    "Calculator" \
		    "Process Management" \
		    "Editor" \
                    "File Management" \
                    "Exit")
    if [ "$choice" = "extra-button-1" ]; then
            # Display the date and time in a dialog
            zenity --info --text="$datetime" --width=300 --height=100
    else
            # Handle user choice
            case "$choice" in
                 "File Explorer")
                      zenity --info --text="Launching File Explorer..."
	              file_explorer
                      ;;
	         "Sudoku")
	              gnome-sudoku
	              ;;
                 "Terminal")
                      zenity --info --text="Launching Terminal..."
                      gnome-terminal -x bash -c "exec bash"
                      ;;
	         "Calculator")
	              gnome-calculator
	              ;;
	 	 "Process Management")
	    	      process_management
	    	      ;;
		 "Editor")
	              open_editor
	              ;;
       		 "File Management")
                      while true; do
                             choice1=$(zenity --list --title="MyShell OS" --text="Choose an option:" \
                                   --column="Option" \
				   --extra-button="Date and Time:$datetime" \
				   --width=600 --height=400 \
                                   "Create File" \
                                   "Delete File" \
                                   "Rename File" \
                                   "Back")
			     if [ "$choice" = "extra-button-1" ]; then
           			    # Display the date and time in a dialog
                                    zenity --info --text="$datetime" --width=300 --height=100
			     else
                                    case "$choice1" in
                                         "Create File")
                                              create_file
                                              ;;
                                         "Delete File")
                                              delete_file
                                              ;;
                                         "Rename File")
                                              rename_file
                                              ;;
                                         "Back")
                                              break
                                              ;;
                                    esac
			     fi
                      done
                      ;;
                 "Exit")
                      zenity --info --text="Exiting MyShell OS..."
                      exit
                      ;;
                 *)
                      zenity --error --text="Invalid choice. Please try again."
                      ;;
            esac
       fi
done
