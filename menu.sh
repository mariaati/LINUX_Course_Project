#!/bin/bash

CURRENT_FILE=""

#func to display the menu
function show_menu() {
    echo " Plant Csv Management Menu"
    echo "============================"
    echo "1) Create Csv file and set it as current"
    echo "2) Select an existing file as current"
    echo "3) View current Csv file"
    echo "4) Add a new row for a specific plant"
    echo "5) Run Python script to create diagrams"
    echo "6) Update values for a specific plant"
    echo "7) Delete a row by its index or plant name"
    echo "8) Find the plant w the highest average leaf count"
    echo "9) Exit"
}

#func to create a new csv
function create_csv() {
    read -p "enter the new csv filename: " filename
    echo "Plant,Height,Leaf Count,Dry Weight" > "$filename"
    CURRENT_FILE="$filename"
    echo "created and set curr csv: $filename"
}

#func to select an existing csv file
function select_csv() {
    read -p "enter csv filename to select: " filename
    if [[ -f "$filename" ]]; then
        CURRENT_FILE="$filename"
        echo "Selected $filename as the current csv file"
    else
        echo "ERROR! file not found"
    fi
}

#func to view the current csv file
function view_csv() {
    if [[ -n "$CURRENT_FILE" && -f "$CURRENT_FILE" ]]; then
        cat "$CURRENT_FILE"
    else
        echo "no csv file selected or it doesnt exist"
    fi
}

#func to add a new row
function add_row() {
    if [[ -z "$CURRENT_FILE" ]]; then
        echo "No CSV file selected!"
        return
    fi
    read -p "enter the plant name: " plant
    read -p "enter the heights : " heights
    read -p "enter the leaf counts : " leaves
    read -p "enter the dry weights : " weights
    echo "$plant,\"$heights\",\"$leaves\",\"$weights\"" >> "$CURRENT_FILE"
    echo "added: $plant to $CURRENT_FILE"
}

#func to run python script and generate diagrams
function run_python_script() {
    if [[ -z "$CURRENT_FILE" ]]; then
        echo "no csv file selected!"
        return
    fi
    read -p "enter the plant name: " plant
    row=$(grep "^$plant," "$CURRENT_FILE")

    if [[ -z "$row" ]]; then
        echo "ERROR! plant not found in file"
        return
    fi

    height=$(echo "$row" | awk -F ',' '{print $2}' | tr -d '"')
    leaves=$(echo "$row" | awk -F ',' '{print $3}' | tr -d '"')
    weight=$(echo "$row" | awk -F ',' '{print $4}' | tr -d '"')

    python3 Work/Q2/plant_plots.py --plant "$plant" --height $height --leaf_count $leaves --dry_weight $weight
}

#func to update row for a plant
function update_row() {
    if [[ -z "$CURRENT_FILE" ]]; then
        echo "no csv file selected!"
        return
    fi
    read -p "enter the plant name to update: " plant
    row=$(grep "^$plant," "$CURRENT_FILE")

    if [[ -z "$row" ]]; then
        echo "ERROR! plant not found in file"
        return
    fi

    read -p "enter the new heights: " new_heights
    read -p "enter the new leaf counts: " new_leaves
    read -p "enter the new dry weights: " new_weights

    awk -v p="$plant" -v h="$new_heights" -v l="$new_leaves" -v w="$new_weights" -F ',' 'BEGIN {OFS=","} $1 == p {print $1, "\"" h "\"", "\"" l "\"", "\"" w "\""; next} {print}' "$CURRENT_FILE" > temp.csv && mv temp.csv "$CURRENT_FILE"

    echo "updated plant: $plant"
}

#func to delete a row by plant name or index
function delete_row() {
    if [[ -z "$CURRENT_FILE" ]]; then
        echo "no csv file selected!"
        return
    fi
    read -p "enter the plant name or row index to delete: " input
    grep -v "^$input," "$CURRENT_FILE" > temp.csv && mv temp.csv "$CURRENT_FILE"
    echo "deleted row w identifier: $input"
}

#func to find plant w highest avg leaf count
function highest_avg_leaf() {
    if [[ -z "$CURRENT_FILE" ]]; then
        echo "no csv file selected!"
        return
    fi
    awk -F ',' 'NR>1 {split($3, a, " "); sum=0; for (i in a) sum+=a[i]; avg=sum/length(a); if (avg > max) { max=avg; plant=$1 } } END { print "Plant with highest avg leaves:", plant, "(", max, ")" }' "$CURRENT_FILE"
}

while true; do
    show_menu
    read -p "enter choice [1-9]: " choice
    case $choice in
        1) create_csv ;;
        2) select_csv ;;
        3) view_csv ;;
        4) add_row ;;
        5) run_python_script ;;
        6) update_row ;;
        7) delete_row ;;
        8) highest_avg_leaf ;;
        9) echo "Exiting..."; break ;;
        *) echo "Invalid choice, try again." ;;
    esac
done
