rule filter_variants:
    input:
        "results/variants/{sample}.raw.vcf.gz"
    output:
        "results/variants/{sample}.filtered.vcf.gz"
    params:
        min_dp=config["filtering"]["min_depth"],
        min_vaf=config["filtering"]["min_vaf"]
    conda:
        "../envs/variant.yml"
    shell:
        "bcftools filter -i 'INFO/DP>={params.min_dp}' {input} -Oz -o {output} && tabix -p vcf {output}"
