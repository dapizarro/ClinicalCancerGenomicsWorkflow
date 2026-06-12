rule bcftools_call:
    input:
        bam="results/bam/{sample}.sorted.dedup.bam",
        bai="results/bam/{sample}.sorted.dedup.bam.bai",
        ref=config["reference"]["genome_fasta"]
    output:
        "results/variants/{sample}.raw.vcf.gz"
    conda:
        "../envs/variant.yml"
    shell:
        "mkdir -p results/variants && bcftools mpileup -Ou -f {input.ref} {input.bam} | bcftools call -mv -Oz -o {output} && tabix -p vcf {output}"
