# ClinicalCancerGenomicsWorkflow

**ClinicalCancerGenomicsWorkflow** is a reproducible bioinformatics framework for cancer targeted/panel NGS analysis, from raw patient FASTQ files to variant calling, clinical annotation, biomarker prioritisation, tumour mutational burden (TMB), and survival modelling.

The project is designed for translational cancer genomics studies where genomic biomarkers are integrated with pathology, immune markers, and clinical outcome data. It was conceptually inspired by early-stage high-grade serous ovarian carcinoma studies integrating BRCA1/2 mutation status, TMB, PD-L1, tumour-infiltrating lymphocytes and survival outcomes.

> Patient-level data are **not included**. The repository contains synthetic example metadata and toy FASTQ placeholders only. Use it with protected local clinical datasets.
---
## Scientific Background

This repository was developed from bioinformatics and statistical analysis workflows applied to the study of molecular and immune prognostic factors in ovarian cancer. The analytical framework implemented here builds upon experience gained during the following study:
> Pizarro D., et al . (2023) The Prognostic Significance of Tumor-Infiltrating Lymphocytes, PD-L1, BRCA Mutation Status and Tumor Mutational Burden in Early-Stage High-Grade Serous Ovarian Carcinoma—A Study by the Spanish Group for Ovarian Cancer Research (GEICO).
International Journal of Molecular Sciences 24(13):11183.

This study integrated histopathological, immunological, genomic and clinical data to investigate prognostic biomarkers in early-stage high-grade serous ovarian carcinoma, including tumor-infiltrating lymphocytes (TILs), PD-L1 expression, BRCA mutational status and tumor mutational burden (TMB).

The workflows implemented in this repository generalize and extend several of the analytical strategies used during this project, providing a reproducible framework for transcriptomic, genomic and clinical association analyses.
---

## What the workflow does

```text
FASTQ
  ↓
FastQC / MultiQC
  ↓
Trimming
  ↓
BWA-MEM alignment
  ↓
BAM sorting, indexing, duplicate marking
  ↓
Variant calling
  ↓
Variant filtering
  ↓
Functional annotation
  ↓
ClinVar / population / cancer database matching
  ↓
Variant prioritisation
  ↓
BRCA1/BRCA2 and custom gene panel summaries
  ↓
TMB estimation
  ↓
Clinical + immune + genomic integration
  ↓
Kaplan-Meier, Cox models and report generation
```

---

## Repository structure

```text
ClinicalCancerGenomicsWorkflow/
├── config/                         # Main configuration files
├── data/
│   ├── raw/fastq/                   # Real FASTQ files, not tracked by git
│   ├── metadata/                    # Sample, clinical, immune and survival tables
│   ├── reference/                   # Reference genome and indexes, not tracked
│   └── example/                     # Synthetic toy data
├── workflow/
│   ├── Snakefile                    # Main Snakemake entry point
│   ├── rules/                       # Modular workflow rules
│   └── envs/                        # Conda environments
├── scripts/
│   ├── python/                      # Variant processing, TMB and integration scripts
│   └── R/                           # Survival modelling and report scripts
├── resources/
│   ├── panels/                      # Gene panels of interest
│   └── databases/                   # ClinVar/COSMIC/gnomAD placeholders
├── results/                         # Workflow outputs, not tracked
├── docs/                            # Documentation
└── tests/                           # Minimal structural tests
```

---

## Quick start

### 1. Create the environment

```bash
mamba env create -f environment.yml
mamba activate clinical-cancer-genomics
```

### 2. Add your FASTQ files

Put paired-end FASTQ files in:

```text
data/raw/fastq/
```

Expected naming by default:

```text
SAMPLE01_R1.fastq.gz
SAMPLE01_R2.fastq.gz
```

### 3. Edit the sample sheet

Edit:

```text
data/metadata/samplesheet.csv
```

Required columns:

```text
sample_id,patient_id,fastq_r1,fastq_r2,tumor_purity,panel_mb
```

### 4. Configure references and databases

Edit:

```text
config/config.yaml
```

At minimum, set:

```yaml
reference:
  genome_fasta: data/reference/hg38.fa
  known_sites_vcf: data/reference/known_sites.vcf.gz
annotation:
  clinvar_tsv: resources/databases/clinvar_minimal.tsv
  population_tsv: resources/databases/population_frequency_minimal.tsv
```

### 5. Run the pipeline

Dry run:

```bash
snakemake -n --cores 4
```

Full run:

```bash
snakemake --cores 16 --use-conda
```

Generate report:

```bash
snakemake results/reports/final_report.html --cores 8 --use-conda
```

---

## Main outputs

```text
results/qc/multiqc_report.html
results/bam/{sample}.sorted.dedup.bam
results/variants/{sample}.filtered.vcf.gz
results/annotation/{sample}.annotated.tsv
results/prioritized/{sample}.prioritized.tsv
results/tmb/tmb_summary.tsv
results/integration/master_clinical_genomics_table.tsv
results/survival/km_overall_survival.pdf
results/survival/cox_multivariate_forest.pdf
results/reports/final_report.html
```

---

## Main analyses

### Variant filtering

Default filtering keeps variants passing configurable thresholds:

- minimum depth
- minimum allele fraction
- minimum genotype quality
- exclusion of high-frequency population variants
- optional restriction to a clinically relevant panel

### Variant prioritisation

Variants are ranked according to:

- ClinVar clinical significance
- predicted consequence
- gene membership in cancer/HRD/BRCA panels
- allele fraction
- population frequency
- recurrence across samples

### TMB

TMB is estimated as:

```text
number of eligible somatic nonsynonymous variants / callable panel size in Mb
```

For tumour-only panels, this should be interpreted cautiously and depends strongly on filtering, germline depletion and panel design.

### Survival modelling

The R module performs:

- Kaplan-Meier curves
- log-rank tests
- univariate Cox models
- multivariate Cox models
- forest plots
- biomarker association tests

---

## Metadata templates

### Clinical metadata

```text
sample_id,patient_id,age,stage,grade,treatment,follow_up_months,relapse,death,os_months,rfs_months
```

### Immune/pathology metadata

```text
sample_id,cd8_intraepithelial,cd8_stromal,cd4_intraepithelial,cd4_stromal,pdl1_tps
```

### Genomic biomarkers

Generated automatically:

```text
sample_id,brca1_status,brca2_status,hrd_gene_mutated,tmb,tmb_group
```

---
## Project Status

### Active Development

This repository consolidates analytical workflows developed across multiple cancer genomics and transcriptomics projects. While individual components have been applied in peer-reviewed publications, the complete integrated workflow has not been published as a standalone software resource. The repository is actively maintained and will continue to evolve as new analyses and methodological improvements are incorporated.

---

## Citation

If you use this repository, please cite the Zenodo DOI: https://doi.org/10.5281/zenodo.20700500

---

## Disclaimer

This workflow is intended for research use. It is not a certified clinical diagnostic pipeline. Clinical interpretation of variants must be performed by qualified professionals following local regulations and validated procedures.
