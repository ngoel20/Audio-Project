#!/bin/bash

# Check if correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 origin_path final_path csv_path"
    exit 1
fi

origin_path="$1"
final_path="$2"
csv_path="$3"

# Check if origin_path and final_path exist
if [ ! -d "$origin_path" ]; then
    echo "Error: Origin path does not exist."
    exit 1
fi

if [ ! -d "$final_path" ]; then
    echo "Error: Final path does not exist."
    exit 1
fi

# Check if csv_path exists
if [ ! -f "$csv_path" ]; then
    echo "Error: CSV file does not exist."
    exit 1
fi

# Read the CSV file and move files accordingly
while read -r filename label; do
    # Trim leading/trailing whitespace from label
    label=$(echo "$label" | xargs)
    # Extract just the filename from the full path
    filename=$(basename "$filename")
    # Create directory if it doesn't exist
    label_path="$final_path/$label"
    if [ ! -d "$label_path" ]; then
        mkdir -p "$label_path"
    fi
    # Move the file to final_path/label
    if [ -f "$origin_path/$filename" ]; then
        mv "$origin_path/$filename" "$label_path/"
        echo "Moved $filename to $label_path/"
    else
        echo "Error: $filename not found in origin path."
    fi
done < "$csv_path"
