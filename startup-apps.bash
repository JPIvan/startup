#!/bin/bash

# Get the directory of the current script file
SCRIPT_DIR=$1
echo "========================================"
echo "Running startup-apps.bash with script directory"
echo "$SCRIPT_DIR"
echo "----------------------------------------"


# Read the startup-apps.yml file and extract the app names and paths
app_data=$(grep -oP '^\w+:\s.*' $SCRIPT_DIR/startup-apps.yml)

# Loop through the app data and open each app
while read -r line; do
    # Extract the app name and path from the line, removing leading and trailing spaces
    app_name=$(
        echo "$line" |
        cut -d':' -f1 |
        sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
    )
    app_path=$(
        echo "$line" |
        cut -d':' -f2- |
        sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
    )


    # Extract the directory containing the executable file
    app_dir=$(dirname "$app_path")
    app_dir="${app_dir/#\~/$HOME}"  # Replace '~' with the home directory
    app_exec=$(basename "$app_path")

    # Add the app directory to the PATH if it begins with a '/'
    if [[ "$app_dir" == /* ]]; then
        export PATH="$app_dir:$PATH"
        echo "Added $app_dir to PATH."
    fi

    # Open the app and print its name and path
    echo "Opening $app_name."
    "$app_exec" &
done <<< "$app_data"

echo "========================================"
