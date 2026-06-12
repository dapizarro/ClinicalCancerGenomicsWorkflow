# Biomarker and survival analysis

The statistical module integrates:

- Clinical metadata.
- Immune biomarkers, such as CD4/CD8 TILs and PD-L1 TPS.
- Genomic biomarkers, such as BRCA1/2 status and TMB.

Implemented analyses:

- Wilcoxon tests for continuous biomarker comparisons.
- Fisher tests for categorical associations.
- Kaplan-Meier survival curves.
- Log-rank tests.
- Cox proportional hazards models.
- Multivariate Cox forest plots.

The workflow is intentionally general: it can be applied to ovarian cancer, breast cancer, lung cancer or any cohort with survival and biomarker metadata.
