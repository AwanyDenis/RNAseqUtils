#!/bin/bash

#PBS -N recodeFQ
#PBS -P XXXXX
#PBS -q smp
#PBS -l select=1:ncpus=24
#PBS -l walltime=96:00:00
##PBS -m bae
##PBS -M XXXXXXX

# Load required modules
module purge
module load chpc/BIOMODULES

# PURPOSE: It's common for fastq files from sequencing machines to be received in formats where machine lane IDs as used to name the fastq files
# and with files in corresponding sample directory [e.g sample1/XXXXX.fq_1.gz, sample1/XXXXX.fq_2.gz, sample2/XXXXX.fq_1.gz,sample2/XXXXX.fq_2.gz]. 
# We want to rename these files so that machine IDs are replaced by sample IDs [e.g sample1/sample1.fq_1.gz, sample1/sample1.fq_2.gz].

# Directory containing raw (with machine-assigned IDs) NGS fastq files
dirName=A055

# Directory to store the renamed fastqFiles
mkdir -p ${dirName}_fastqFiles

path1=/mnt/lustre/users/adenis/$dirName/*
outDir=/mnt/lustre/users/adenis/${dirName}_fastqFiles

# Rename machine lane labels to sample IDs
for Sample in $path1
do
	base1=$(basename $Sample )
	for fqFile in ${path1}${base1}/*.gz
	do
		base2=$(basename $fqFile )
		str="${base2%%_L0*}"	
		rename $str $base1 $fqFile
	done
done

# Move the renamed files from the inner directories to one location (output directory) for all samples.
for file in ${path1}/*.gz
do
	mv $file ${outDir}/
done

