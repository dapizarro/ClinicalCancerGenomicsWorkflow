rule annotate_variants:
    input:
        vcf="results/variants/{sample}.filtered.vcf.gz",
        clinvar=config["annotation"]["clinvar_tsv"],
        population=config["annotation"]["population_tsv"]
    output:
        "results/annotation/{sample}.annotated.tsv"
    conda:
        "../envs/python.yml"
    shell:
        "python scripts/python/annotate_variants.py --vcf {input.vcf} --clinvar {input.clinvar} --population {input.population} --sample {wildcards.sample} --out {output}"
