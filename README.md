# Optimizing Slurm Usage 

This tool can be used to optimize your Slurm jobs and improve CPU, GPU, Memory and Time efficiencies. 

 It generates an HTML report based on Slurm accounting information, helping users understand the resource consumption of their jobs. 

## Overview   

The tool can be run on the head node of the Exacloud cluster in two primary ways:

1. **Directly with Parameters**: Use command-line options to specify details for querying Slurm accounting data.
2. **Using a Pre-generated File**: Input a file that contains Slurm accounting data.

## Files Included (in SlurmUsageReport folder)

- **`slurm_environment.yml`** – File containing the required conda environment.
- **`SlurmReport.sh`** – Main script to run the tool.
- **`SlurmJobAssessment.Rmd`** – R Markdown file that summarizes data and generates an HTML report. 

## Usage

You can run the tool in two primary ways:

### 1. Using Command-Line Parameters

Run the script directly with the following command:

```bash
./SlurmReport.sh -u <user> -s <start_date> -e <end_date> -a <accounts>
```
- **`-u <user>`** : User(s) to filer by. Filter for multiple users by inputting comma separated values. 
If omitted, data for all users will be included. 

- **`-s <start_date>`** : Start date in the format `YYYY-MM-DD`. If omitted, start date will be 7 days before end date. 

- **`-e <end_date>`** : End date in the format `YYYY-MM-DD`. If omitted, end date will be the current date. 

- **`-a <accounts>`** : Account(s) to filter by. Include multiple accounts by inputting comma separated values. If omitted, default will be `cedar,cedar2`. 

For example, to summarize data for user chaoe from 2024-07-01 to 2024-07-10 for accounts cedar and cedar2:

```bash
./SlurmReport.sh -u chaoe -s 2024-07-01 -e 2024-07-10
```


### 2. Using a Pre-generated File 
If you have a file already generated from `sacct`, you can input the file directly with the following command: 

```bash
./SlurmReport.sh -f <file>
```
- **`-f <file>`** : Path to sacct file. The file must include the neccessary columns required to calculate the slurm statistics and generate the HTML report. 

For example, an acceptable file would be generated like this : 

```bash 
sacct --units=G --format=JobIdRaw,JobName,User,Group,Account,State,Submit,Start,End,Cluster,Partition,AllocNodes,AllocTRES,AllocCPUS,ReqCPUs,AveCPU,TotalCPU,CPUTime,UserCPU,SystemCPU,Elapsed,Timelimit,ReqMem,MaxRSS,MaxVMSize,MaxDiskWrite,MaxDiskRead,CPUTimeRaw,ElapsedRaw,TimelimitRaw,SubmitLine --parsable2 -a -A cedar,cedar2 --starttime=2024-07-01 --endtime=2024-07-10 -u chaoe
```

You cannot use both methods at the same time. If you provide both a file and other parameters into the tool, the tool will ignore your extra parameters and use only the file. 

#### Running on Exacloud Compute Node

For optimal performance, it is recommended to run the tool on the head node of Exacloud. However, it can be run on a compute node using this command: 

```bash 
srun ./SlurmReport.sh
```

### Troubleshooting 

#### No Data is Retrieved 
This will be stated on the resulting HTML report and indicates that no jobs were found from the given inputs. 

Recheck the parameters inputted. If you had inputted a file, refer to the example of an acceptable file above to see if the required sacct columns were present in your file. 


#### Permission Denied when Executing Shell Script
This will appear in the terminal when execute permissions have not been allowed. Add permissions with this command: 
```bash 
chmod 755 SlurmReport.sh 
```


### Additional Information 

SlurmStatsWrangling.rmd is a separate script to parse through sacct outputs. 

Resources about slurm usage and sacct data can be found here: 
https://slurm.schedmd.com/sacct.html
https://ohsu-cedar-comp-hub.github.io/2023/09/19/Right-Sizing-Slurm-Jobs.html

If you have any questions about anything, feel free to reach out to me! (chaoe@ohsu.edu)



