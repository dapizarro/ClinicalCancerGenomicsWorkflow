rule survival_models:
    input:
        "results/integration/master_clinical_genomics_table.tsv"
    output:
        cox="results/survival/cox_multivariate_results.tsv",
        km_os="results/survival/km_overall_survival.pdf",
        forest="results/survival/cox_multivariate_forest.pdf"
    conda:
        "../envs/r.yml"
    shell:
        "mkdir -p results/survival && Rscript scripts/R/survival_analysis.R {input} results/survival"
