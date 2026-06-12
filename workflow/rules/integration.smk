rule integrate_clinical_genomics:
    input:
        clinical=config["clinical_metadata"],
        immune=config["immune_metadata"],
        tmb="results/tmb/tmb_summary.tsv",
        prioritized=expand("results/prioritized/{sample}.prioritized.tsv", sample=SAMPLES)
    output:
        "results/integration/master_clinical_genomics_table.tsv"
    conda:
        "../envs/python.yml"
    shell:
        "mkdir -p results/integration && python scripts/python/merge_clinical_genomics.py --clinical {input.clinical} --immune {input.immune} --tmb {input.tmb} --variants results/prioritized --out {output}"
