#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library(tidyverse)
  library(survival)
  library(survminer)
  library(broom)
})

args <- commandArgs(trailingOnly = TRUE)
input <- args[1]
outdir <- args[2]
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

df <- read_tsv(input, show_col_types = FALSE)

# Ensure factors are explicit
factor_cols <- c("stage", "cd8_intraepithelial_group", "cd4_intraepithelial_group", "brca_status", "tmb_group", "pdl1_status")
for (cc in intersect(factor_cols, names(df))) df[[cc]] <- as.factor(df[[cc]])

# Kaplan-Meier overall survival by CD8 group
if (all(c("os_months", "death", "cd8_intraepithelial_group") %in% names(df))) {
  fit <- survfit(Surv(os_months, death) ~ cd8_intraepithelial_group, data = df)
  p <- ggsurvplot(fit, data = df, pval = TRUE, risk.table = TRUE,
                  title = "Overall survival by intraepithelial CD8 group")
  ggsave(file.path(outdir, "km_overall_survival.pdf"), p$plot, width = 7, height = 5)
}

# Multivariate Cox model with robust fallback
covars <- c("age", "stage", "cd8_intraepithelial_group", "cd4_intraepithelial_group", "brca_status", "tmb_group")
covars <- covars[covars %in% names(df)]
cox_formula <- as.formula(paste("Surv(os_months, death) ~", paste(covars, collapse = " + ")))
cox <- coxph(cox_formula, data = df)
res <- tidy(cox, exponentiate = TRUE, conf.int = TRUE)
write_tsv(res, file.path(outdir, "cox_multivariate_results.tsv"))

# Forest plot
pdf(file.path(outdir, "cox_multivariate_forest.pdf"), width = 8, height = 5)
print(ggforest(cox, data = df))
dev.off()
