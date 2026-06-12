rule sort_bam:
    input:
        "results/bam/{sample}.sam"
    output:
        "results/bam/{sample}.sorted.bam"
    conda:
        "../envs/alignment.yml"
    shell:
        "samtools sort -o {output} {input} && rm -f {input}"

rule mark_duplicates:
    input:
        "results/bam/{sample}.sorted.bam"
    output:
        bam="results/bam/{sample}.sorted.dedup.bam",
        metrics="results/bam/{sample}.duplication_metrics.txt"
    conda:
        "../envs/alignment.yml"
    shell:
        "picard MarkDuplicates I={input} O={output.bam} M={output.metrics} REMOVE_DUPLICATES=false VALIDATION_STRINGENCY=SILENT"

rule index_bam:
    input:
        "results/bam/{sample}.sorted.dedup.bam"
    output:
        "results/bam/{sample}.sorted.dedup.bam.bai"
    conda:
        "../envs/alignment.yml"
    shell:
        "samtools index {input}"
