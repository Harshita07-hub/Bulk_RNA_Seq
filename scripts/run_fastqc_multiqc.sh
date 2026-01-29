#!/bin/bash

#!/bin/bash

# Quality control of raw FASTQ files
# Step 1: Run FastQC on all FASTQ files
fastqc fastq/*.fastq.gz -o fastqc_results/ --threads 2


# Step 2: Summarize FastQC reports using MultiQC
 multiqc fastqc_results/ -o multiqc_report/

