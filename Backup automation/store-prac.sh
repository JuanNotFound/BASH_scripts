#!/bin/bash

origin=$1
destination=$2

mkdir -p "$destination"

for student_dir in "$origin"/*; do 
        if [[ -d "$student_dir" ]]; then 
                login=$(basename "$student_dir")
                prac_file"$student_dir/prac.sh"
                if [[ -f "$prac_file" ]]; then 
                        cp "$prac_file" "$destination/$login.sh"
                fi
        fi
done

