#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
master <- args[1]
cox <- args[2]
out <- args[3]
html <- paste0("<html><head><title>Clinical Cancer Genomics Report</title></head><body>",
"<h1>Clinical Cancer Genomics Workflow Report</h1>",
"<p>This automatically generated report summarises the integrated clinical, immune and genomic analysis.</p>",
"<h2>Input tables</h2><ul>",
"<li>Master table: ", master, "</li>",
"<li>Cox results: ", cox, "</li>",
"</ul>",
"<h2>Key outputs</h2><ul>",
"<li>Kaplan-Meier curves: results/survival/km_overall_survival.pdf</li>",
"<li>Cox forest plot: results/survival/cox_multivariate_forest.pdf</li>",
"</ul></body></html>")
cat(html, file = out)
