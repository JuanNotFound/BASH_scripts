#!/bin/sh


PATH_BROWSER="/Applications/Safari.app"

if [ $# -eq 0 ]; then 
    echo "Error, you have to include a path to the file to read."
    exit 1
else
    FILE="$1"
    if [ -f "$FILE" ]; then 
        while IFS= read -r line
        do
            echo "Abriendo: $line"
            open "$line"
        done < "$FILE"
    else
        echo "Error, file doesn't exist."
        exit 1
    fi
fi






