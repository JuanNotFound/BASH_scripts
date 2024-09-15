#!/usr/bin/bash

read -p "Enter block duration (in minutes): " block_min
read -p "Enter rest duration (in minutes): " rest_min
read -p "Enter number of blocks: " n_blocks

# Convertir minutos a segundos
block_sec=$((block_min * 60))
rest_sec=$((rest_min * 60))

n_rest=$((n_blocks - 1))

block_counter=0
rest_counter=0

total_time=$((n_blocks * block_sec + n_rest * rest_sec))
local_timer=$block_sec
status="block"

while [ $total_time -gt 0 ] && [ $block_counter -lt $n_blocks ]; do
    if [ $local_timer -le 0 ]; then
        if [ "$status" == "block" ]; then
            block_counter=$((block_counter + 1))
            if [ $block_counter -lt $n_blocks ]; then
                local_timer=$rest_sec
                status="rest"
                echo "Block completed. Switching to rest."
            else
                local_timer=0
                status="done"
                echo "All blocks completed."
            fi
        else
            rest_counter=$((rest_counter + 1))
            local_timer=$block_sec
            status="block"
            echo "Rest completed. Switching to block."
        fi
    fi

    echo "$local_timer seconds remaining in current $status"
    sleep 1
    local_timer=$((local_timer - 1))
    total_time=$((total_time - 1))
done
