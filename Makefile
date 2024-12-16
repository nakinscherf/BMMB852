# BMMB852 Assignment 14
# 20241215 Kinscherf
# Makefile assumes installation of micromamba bioinfo environment, the Biostar handbook stats environment, and bio code bioinformatics toolbox

# Shell defaults
SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

usage:
	@echo "simulate	# Simulate an RNA-seq count matrix"
	@echo "edgeR	# Run edgeR using counts.csv and design.csv to find differential expression"
	@echo "evaluate	# Print information comparing results of edgeR using simulated data with known changes in simulated data"
	@echo "pca	# Create a PCA plot of the edgeR results to visualize consistency within groups"
	@echo "heatmap	# Create a heatmap of the edgeR results to visualize patterns of differential expression"

simulate:
	Rscript src/r/simulate_counts.r 

edgeR:
	Rscript src/r/edger.r

evaluate:
	Rscript  src/r/evaluate_results.r  -a counts.csv -b edger.csv

pca:
	src/r/plot_pca.r -c edger.csv

heatmap:
	src/r/plot_heatmap.r -c edger.csv

all: simulate edgeR evaluate pca heatmap

