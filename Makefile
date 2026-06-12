.PHONY: env dryrun run clean report

env:
	mamba env create -f environment.yml

dryrun:
	snakemake -n --cores 4

run:
	snakemake --cores 16 --use-conda

report:
	snakemake results/reports/final_report.html --cores 8 --use-conda

clean:
	rm -rf .snakemake results/*
