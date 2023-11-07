#!/bin/bash

SCRIPT_DIR=$1
echo "========================================"
echo "Running startup-git-repos.bash with script directory"
echo "$SCRIPT_DIR"
echo "----------------------------------------"

HOME_DIR="$HOME"
PROJECT_DIR="$HOME_DIR/Documents/Projects"

# List of directories to update
projects=$(grep 'Projects:' $SCRIPT_DIR/startup-git-repos.yaml -A 1000 |  # read 1000 lines after 'Projects:'
    grep -v 'Projects:' |  # remove the line containing 'Projects:'
    grep -v '#' |  # remove comments
    sed '/^\s*$/d; s/^[[:blank:]]*//; s/[[:blank:]]*$//' |  # remove whitespace see below ***
    sed 's/^- //' |  # remove the '- ' from the list syntax in the yaml file
    sed "s|^|$PROJECT_DIR/|"  # add the project directory to the beginning of each line
    )
# ***
# /^\s*$/d: This removes any blank lines
# s/^[[:blank:]]*//: This removes any leading whitespace from each line.
# s/[[:blank:]]*$//: This removes any trailing whitespace from each line.

# DIRS=(
#   "$PROJECT_DIR/zettelkasten"
# )

# Loop through each directory and run git pull
for project in $projects
do
  echo "Updating $project"
  cd "$project" || exit
  git pull
done

echo "========================================"