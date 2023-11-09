#!/usr/bin/python3

# SCRIPT: convert_STAR_Jxn_reads_to_BED_format.py
# AUTHOR: South African Tuberculosis (SATVI) Bioanalytical Node
# MAINTAINER: Denis Awany 
# DATE: 24/05/2021
# REV: 1.0
# PLATFORM: Linux
#PURPOSE: This script converts the splice junction reads (.SJ.out.tab file) from the STAR alignment tool
#	  to BED format. This is necessary for analysis where read counts is required at the level of splice junctions.
#	
#	    The software is free: you can redistribute it and/or modify it as desired. It is hoped that it
#            will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of FITNESS FOR A PARTICULAR PURPOSE.     

#   Usage:  python convert_STAR_Jxn_reads_to_BED_format.py -f InputFileName.SJ.out.tab -o OutputFileName.SJ.bed




# Converts the uniquely mapped splice junction reads (column 7 in the .SJ.out.tab output from STAR) to a BED6 format

import sys,argparse,os.path

argparser = argparse.ArgumentParser(description='Converts a STAR junction file into a 6-column BED file.')
argparser.add_argument('-m','--multi',help='Flag to sum uniquely mapped junction reads and multi-mapping reads. (Default is to keep only uniquely mapped reads.)',action='store_true')
argparser.add_argument('-f','--starfile',help='STAR junction file',required=True)
argparser.add_argument('-o','--outfile',help='Output file name. (If omitted, the same file name but with a .bed extension will be used.)')

args = argparser.parse_args()

if not os.path.exists(args.starfile):
	print 'ERROR file '+args.starfile+' does not exists!'
	sys.exit()
	
if not args.outfile:
	l=len(args.starfile)
	ext=args.starfile[l-4:]
	if ext=='.csv' or ext=='.tab' or ext=='.txt' or ext=='.tsv':
		args.outfile = args.starfile[:l-4]+'.bed'
	else:
		args.outfile = args.starfile+'.bed'

out=open(args.outfile,'w')
for l in open(args.starfile,'r'):
	toks=l.strip().split('\t')
	cnt=int(toks[6])
	if args.multi:
		cnt += int(toks[7])
	
	strand = '-'
	if toks[3]=='1':
		strand = '+'
		
	out.write("\t".join([toks[0], toks[1], toks[2], 'jxn', str(cnt), strand]) + '\n')
		
out.close()
print 'Output file written in '+args.outfile
