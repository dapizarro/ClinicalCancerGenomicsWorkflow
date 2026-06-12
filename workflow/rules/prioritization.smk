rule prioritize_variants:
    input:
        annotated="results/annotation/{sample}.annotated.tsv",
        panel=config["annotation"]["priority_gene_panel"]
    output:
        "results/prioritized/{sample}.prioritized.tsv"
    conda:
        "../envs/python.yml"
    shell:
        "python scripts/python/prioritize_variants.py --annotated {input.annotated} --panel {input.panel} --out {output}"
