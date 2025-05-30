# Optimizing Slurm Usage 

There are two tools that can be used separately or together to learn about the performance of specific Slurm jobs and help optimization by improving CPU, GPU, Memory and Time efficiencies. 

** UPDATE : Exacloud has been discontinued. These tools can only be used to extract information about jobs ran on ARC. If you have any questions about past Exacloud jobs/usage data, refer to Contact section. ** 

**Tool 1- Slurm Job Assessment:**

This tool generates an HTML report based on Slurm accounting information, helping users understand the resource consumption of their jobs. It includes full Slurm job information as well as the information grouped by state and user and grouped by job. Users can filter on information and download their data if desired. Visualizations are provided to understand which specific jobs can be improved. 

For any questions on how to navigate this tool and use it to understand how and which jobs need improvement, please refer to Contact section. 

**Tool 2- Slurm Track Usage:**

This tool also generates an HTML report but focuses on creating visualizations for tracking CPU and GPU usage over time for CEDAR/CEDAR2 accounts. 
For the CEDAR condo, only CPU tracking is displayed. 

 The x-axis is divided by the Week, which is determined by the start date of the job(s). Visualizations are also included for data by top 8 users and data by account. The budget is also provided as reference. 


## Overview   

Both tools can be run on the head node of the ARC cluster in two primary ways:

1. **Directly with Parameters**: Use command-line options to specify details for querying Slurm accounting data.
2. **Using a Pre-generated File**: Input a file that contains Slurm accounting data. 

## Files Included (in SlurmTools folder)
**For Slurm Job Assessment Tool**: 
- **`slurm_environment.yml`** – File containing the required conda environment.
- **`JobAssess.sh`** – Main script to run the tool.
- **`SlurmJobAssessment.Rmd`** – R Markdown file that summarizes data and generates an HTML report. 

**For Slurm Track Usage Tool**: 
- **`slurm_environment.yml`** – File containing the required conda environment.
- **`TrackUsage.sh`** – Main script to run the tool.
- **`SlurmTrackUsage.Rmd`** – R Markdown file that creates visualizations to track usage in an HTML report. 


## Usage

### Clone the Repository
Clone the repo using `git clone` to pull all needed files. 
Navigate to the SlurmTools directory. 

You can run the tools in two primary ways:

### 1. Using Command-Line Parameters

Run the script directly with the following command:

```bash
./JobAssess.sh -u <user> -s <start_date> -e <end_date> -a <accounts> -p <partition> -all <all_info>

./TrackUsage.sh -u <user> -s <start_date> -e <end_date> -a <accounts> -p <partition> 
```
- **`-u <user>`** : User(s) to filer by. Filter for multiple users by inputting comma separated values. 
If omitted, data for all users will be included. 

- **`-s <start_date>`** : Start date in the format `YYYY-MM-DD`. If omitted, start date will be 7 days before end date. 

- **`-e <end_date>`** : End date in the format `YYYY-MM-DD`. If omitted, end date will be the current date + 1. 

**NOTE:** `sacct` includes jobs **before** the end parameter. For example, if you want to include jobs that happened on 2025-03-01, you would set end date to be 2025-03-02. 

- **`-a <accounts>`** : Account(s) to filter by. Include multiple accounts by inputting comma separated values. If omitted, default will be `cedar,cedar2, cedar-condo`. 

- **`-p <partition>`** : Partition(s) to filter by. Include multiple partitions by inputting comma separated values. If omitted, default will be all partitions. 

- **`-all <all_info>`** : Shows all information (individual user plots and full tables). Accepts TRUE or FALSE. If omitted, default will be `TRUE`. 

Both tools have the same parameters **EXCEPT** `-all <all_info>` is **NOT** in the Slurm Track Usage tool! 

For example, to summarize all job information and track usage for user chaoe from 2024-07-01 to 2024-07-10 for accounts cedar, cedar2 and cedar-condo:

```bash
./JobAssess.sh -u chaoe -s 2024-07-01 -e 2024-07-10

./TrackUsage.sh -u chaoe -s 2024-07-01 -e 2024-07-10
```

After launching the tool, you will be prompted to enter in your ARC username. Your ARC username is the X in X@ohsu.edu. 


### 2. Using a Pre-generated File 
If you have a file already generated from `sacct`, you can input the file directly with the following command: 

```bash
./JobAssess.sh -f <file>

./TrackUsage.sh -f <file>
```
- **`-f <file>`** : Path to sacct file. The file must include the neccessary columns required to calculate the slurm statistics and generate the HTML report. 

For example, an acceptable file would be generated like this : 

```bash 
sacct --units=G --format=JobIdRaw,JobName,User,Group,Account,State,Submit,Start,End,Cluster,Partition,AllocNodes,AllocTRES,AllocCPUS,ReqCPUs,AveCPU,TotalCPU,CPUTime,UserCPU,SystemCPU,Elapsed,Timelimit,ReqMem,MaxRSS,MaxVMSize,MaxDiskWrite,MaxDiskRead,CPUTimeRaw,ElapsedRaw,TimelimitRaw --parsable2 -a -A cedar,cedar2,cedar-condo --starttime=2023-07-01 --endtime=2024-06-30 > data.txt
```

You cannot use both methods at the same time for either tool. If you provide both a file and other parameters into the tool, the tool will ignore your extra parameters and use only the file. 

* This doesn't apply for `-all <all_info>`. The -all parameter can be used for either methods for the **SlurmJobAssessment** tool.


#### Running on ARC Compute Node

Because these tools are computationally light, it is recommended to run the tools on the head node of ARC following the usage examples above. 
However, it can be run on a compute node using these commands: 

```bash 
srun ./JobAssess.sh

sbatch JobAssess.sh

srun ./TrackUsage.sh

sbatch TrackUsage.sh
```



### Troubleshooting 

#### No Data is Retrieved 
This will be stated on the resulting HTML report and indicates that no jobs were found from the given inputs. 

Recheck the parameters inputted. If you had inputted a file, refer to the example of an acceptable file above to see if the required sacct columns were present in your file. 


#### Permission Denied when Executing Shell Script
This will appear in the terminal when execute permissions have not been allowed. Add permissions with this command: 
```bash 
chmod 755 JobAssess.sh 

chmod 755 TrackUsage.sh
```

#### Report is Taking Too Long to Load 
If the report from the **Slurm Job Assessment** tool is taking too long to load, you can use `-all FALSE` to get a faster report. 

Requesting to look at a lot of data will mean a longer wait time for all information to be loaded. 
This will usually come up if you are looking for FY reports for all users. 

In addition, you can limit the number of users you filter by `-u`. 


#### Why are X Jobs Appearing? 
Both tools use the `sacct` command, so resulting jobs who end within the timeframe are included.
This means that jobs who overlap with the timeframe will be included. 

Additionally, jobs with no specified end date (b/c they are pending or ongoing) are assigned a temporary end date using start date + elapsed. 


### Additional Information 

SlurmStatsWrangling.rmd is a separate script to parse through sacct outputs. 

Resources about slurm usage and sacct data can be found here: 
https://slurm.schedmd.com/sacct.html
https://ohsu-cedar-comp-hub.github.io/2023/09/19/Right-Sizing-Slurm-Jobs.html

### Contact 
If you have any questions about anything, feel free to reach out to me! (chaoe@ohsu.edu)