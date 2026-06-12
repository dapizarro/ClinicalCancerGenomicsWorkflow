# Input data guide

## FASTQ files

Place patient FASTQ files in:

```text
data/raw/fastq/
```

The workflow expects paired-end files by default.

## Sample sheet

Required file:

```text
data/metadata/samplesheet.csv
```

Required columns:

- `sample_id`: unique sample identifier
- `patient_id`: patient identifier
- `fastq_r1`: path to R1 FASTQ
- `fastq_r2`: path to R2 FASTQ
- `tumor_purity`: estimated tumour purity, if available
- `panel_mb`: callable panel size in megabases for TMB calculation

## Clinical metadata

Required columns for survival analysis:

- `sample_id`
- `age`
- `stage`
- `os_months`
- `death`
- `rfs_months`
- `relapse`

## Immune/pathology metadata

Typical columns:

- `cd8_intraepithelial`
- `cd8_stromal`
- `cd4_intraepithelial`
- `cd4_stromal`
- `pdl1_tps`
