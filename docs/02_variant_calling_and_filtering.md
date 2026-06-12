# Variant calling and filtering strategy

This repository provides a practical research workflow for targeted cancer NGS panels.

Default steps:

1. FASTQ quality control.
2. Adapter and quality trimming.
3. BWA-MEM alignment.
4. BAM sorting, duplicate marking and indexing.
5. Variant calling with bcftools.
6. Filtering by depth and allele fraction.
7. Annotation using ClinVar-like and population-frequency tables.
8. Variant prioritisation.

For clinical deployment, replace the default variant caller with a validated caller for the sequencing design, such as Mutect2, VarDict, Strelka2, FreeBayes or vendor-specific pipelines.

Recommended filters for FFPE targeted panels:

- Depth >= 500x when possible.
- Alternate allele depth >= 10–20 reads.
- Variant allele fraction >= 5–10% depending on validation.
- Remove frequent population variants unless clinically relevant.
- Manually inspect clinically actionable variants in IGV.
