rule final_report:
    input:
        master="results/integration/master_clinical_genomics_table.tsv",
        cox="results/survival/cox_multivariate_results.tsv"
    output:
        "results/reports/final_report.html"
    conda:
        "../envs/r.yml"
    shell:
        "mkdir -p results/reports && Rscript scripts/R/render_report.R {input.master} {input.cox} {output}"
