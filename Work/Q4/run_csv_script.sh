#!/bin/bash

LOG_FILE="execution.log"
ERROR_LOG="error.log"
DIAGRAMS_DIR="Diagrams"
BACKUP_DIR="Backups"
VENV_DIR="venv"
REQ_FILE="../Q2/requirements.txt"

#to ensure the log exist
touch "$LOG_FILE" "$ERROR_LOG"

#func to print and log the msgs
log_message() {
    echo "$1" | tee -a "$LOG_FILE"
}

error_message() {
    echo "$1" | tee -a "$ERROR_LOG"
}

#gettin the csv file
if [[ -n "$1" ]]; then
    CSV_FILE="$1"
else
    CSV_FILE=$(find . -maxdepth 1 -name "*.csv" | head -n 1)
fi

if [[ ! -f "$CSV_FILE" ]]; then
    error_message "Error!! Csv file not found!"
    exit 1
fi
log_message "using csv file: $CSV_FILE"

# creating and activatin the veno
if [[ ! -d "$VENV_DIR" ]]; then
    log_message "creating virtual environment venoo"
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

if [[ "$VIRTUAL_ENV" != "" ]]; then
    log_message "virtual environment activated successfully"
else
    error_message "Error!!failed to activate virtual environment!"
    exit 1
fi

#install dependecies
if [[ ! -f "$REQ_FILE" ]]; then
    error_message "ERROR: requirements.txt not found!"
    exit 1
fi

pip install -r requirements.txt

#processing csv files and running python script
mkdir -p "$DIAGRAMS_DIR"

while IFS=',' read -r PLANT HEIGHT LEAVES WEIGHT; do
    if [[ "$PLANT" == "Plant" ]]; then
        continue
    fi
    
    PLANT_DIR="$DIAGRAMS_DIR/$PLANT"
    mkdir -p "$PLANT_DIR"
    
    log_message "processin plant: $PLANT..."
    
    python3 ../Q2/plant_plots.py --plant "$PLANT" --height "$HEIGHT" --leaf_count "$LEAVES" --dry_weight "$WEIGHT" 2>> "$ERROR_LOG"
    
    if [[ $? -eq 0 ]]; then
        log_message "successfully created diagrams for $PLANT."
    else
        error_message "Error!! failed to generate diagrams for $PLANT!"
    fi
    
done < "$CSV_FILE"

#creating backups
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/Diagrams_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"
tar -czvf "$BACKUP_FILE" "$DIAGRAMS_DIR"
log_message "backup created at: $BACKUP_FILE"

deactivate

log_message "script execution completed."
