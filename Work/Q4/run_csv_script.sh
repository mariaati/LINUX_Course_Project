#!/bin/bash

CSV_FILE=""
REQUIREMENTS_FILE="../Q2/requirements.txt"
DIAGRAMS_DIR="Diagrams"
BACKUP_DIR="Backups"
VENV_DIR="venv"

LOG_FILE="execution.log"
ERROR_LOG="error.log"

#to ensure the log exist
touch "$LOG_FILE" "$ERROR_LOG"

#func to print and log the msgs
log_message() {
    echo "$1" | tee -a "$LOG_FILE"
}

#func to log errors
error_message() {
    echo "$1" | tee -a "$ERROR_LOG"
}

#parse command line args
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--path) CSV_FILE="$2"; shift ;;
        -r|--requirements) REQUIREMENTS_FILE="$2"; shift ;;
        -o|--output) DIAGRAMS_DIR="$2"; shift ;;
        -b|--backup) BACKUP_DIR="$2"; shift ;;
        *) error_message "unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

#if theres no csv file provided then it finds one auto
if [[ -z "$CSV_FILE" ]]; then
    CSV_FILE=$(find . -maxdepth 1 -name "*.csv" | head -n 1)
fi

if [[ ! -f "$CSV_FILE" ]]; then
    error_message "Error!! csv file not found!"
    exit 1
fi
log_message "using csv file: $CSV_FILE"

#remove the old diagrams b4 running
log_message "removing old plant folders.."
rm -rf "$DIAGRAMS_DIR"
mkdir -p "$DIAGRAMS_DIR"

#creatin and activating the venv
if [[ ! -d "$VENV_DIR" ]]; then
    log_message "creating virtual environment.."
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

if [[ "$VIRTUAL_ENV" != "" ]]; then
    log_message "virtual environment activated successfully!!"
else
    error_message "Error!! failed to activate virtual environment!!"
    exit 1
fi

#install dependecies
if [[ ! -f "$REQUIREMENTS_FILE" ]]; then
    error_message "Error!! requirements file not found: $REQUIREMENTS_FILE"
    exit 1
fi

pip install -r "$REQUIREMENTS_FILE"

#processin the csv file and running python scriptt
while IFS=',' read -r PLANT HEIGHT LEAVES WEIGHT; do
    if [[ "$PLANT" == "Plant" ]]; then
        continue
    fi

    PLANT_DIR="$DIAGRAMS_DIR/$PLANT"
    mkdir -p "$PLANT_DIR"

    log_message "processing plant: $PLANT..."

    python3 ../Q2/plant_plots.py --plant "$PLANT" --height "$HEIGHT" --leaf_count "$LEAVES" --dry_weight "$WEIGHT" 2>> "$ERROR_LOG"

    if [[ $? -eq 0 ]]; then
        log_message "successfully created diagrams for $PLANT."
    else
        error_message "Error!!failed to generate diagrams for $PLANT!"
    fi

done < "$CSV_FILE"

#creatin the backups
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/Diagrams_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"
tar -czvf "$BACKUP_FILE" "$DIAGRAMS_DIR"
log_message "backup created at: $BACKUP_FILE"

deactivate
log_message "script execution completed"

