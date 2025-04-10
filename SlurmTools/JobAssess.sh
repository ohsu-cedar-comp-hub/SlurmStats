#!/bin/bash
#SBATCH --job-name=assess_jobs       # Job name
#SBATCH --output=%x.%j.log      # Standard output and error log
#SBATCH --ntasks=1                   # Number of tasks
#SBATCH --cpus-per-task=1            # Number of CPU cores per task
#SBATCH --time=00:10:00              # Time limit
#SBATCH --mem=8G                     # Memory allocation

ENV_NAME="slurm_statsenv"

if conda env list | grep -q "$ENV_NAME"; then
    echo "Environment '$ENV_NAME' already exists. Activating..."
else
    echo "Environment '$ENV_NAME' does not exist. Creating and initializing..."
    # Create the environment from the YAML file
    conda env create -f slurm_environment.yml
fi
source activate base
conda init zsh
conda activate "$ENV_NAME"

# Define parameters
USER=""
START=""
END=""
FILE=""
PARTITION=""
ACCT="cedar,cedar2,cedar-condo"
ALL="TRUE"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f) FILE="$2"; shift 2;;
    -u) USER="$2"; shift 2;;
    -s) START="$2"; shift 2;;
    -e) END="$2"; shift 2;;
    -p) PARTITION="$2"; shift 2;;
    -a) ACCT="$2"; shift 2;;
    -all) ALL="$2"; shift 2;;
    --) shift; break;;
    *) echo "Unknown option: $1" >&2; exit 1;;
  esac
done


echo "File: $FILE" 
echo "User: $USER" 
echo "Start: $START"
echo "End: $END"  
echo "Partition: $PARTITION"
echo "Acct: $ACCT"  
echo "All: $ALL"

# Run the RMarkdown file with parameters
Rscript -e "rmarkdown::render('SlurmJobAssessment.Rmd', params = list(user = '$USER', start = '$START', end = '$END', file = '$FILE', partition = '$PARTITION', account = '$ACCT', all = '$ALL'))"