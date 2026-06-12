rule calculate_tmb:
    input:
        expand("results/prioritized/{sample}.prioritized.tsv", sample=SAMPLES),
        samplesheet=config["samplesheet"]
    output:
        "results/tmb/tmb_summary.tsv"
    conda:
        "../envs/python.yml"
    shell:
        "mkdir -p results/tmb && python scripts/python/calculate_tmb.py --variants results/prioritized --samplesheet {input.samplesheet} --out {output}"
