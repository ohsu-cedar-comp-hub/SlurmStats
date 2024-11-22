#!/bin/bash
#SBATCH --job-name=slurm_usagetrack  # Job name
#SBATCH --output=job_output.log      # Standard output and error log
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
ACCT="cedar,cedar2"
PARTITION=""

while getopts ":f:u:s:e:a:p:" opt; 
do
  case ${opt} in
    f )
      FILE=$OPTARG;;
    u )
      USER=$OPTARG;;
    s )
      START=$OPTARG;;
    e )
      END=$OPTARG;;
    a )
      ACCT=$OPTARG;;
    p )
      PARTITION=$OPTARG;;
  esac
done
shift $((OPTIND -1))

echo "File: $FILE" 
echo "User: $USER" 
echo "Start: $START"
echo "End: $END" 
echo "Partition: $PARTITION" 
echo "Acct: $ACCT"  


# Run the RMarkdown file with parameters
Rscript -e "rmarkdown::render('SlurmTrackUsage.Rmd', params = list(user = '$USER', start = '$START', end = '$END', file = '$FILE', partition = '$PARTITION', account = '$ACCT'))"
