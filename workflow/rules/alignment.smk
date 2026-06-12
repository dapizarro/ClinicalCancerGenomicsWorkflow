rule bwa_mem:
    input:
        r1="results/trimmed/{sample}_R1.trimmed.fastq.gz",
        r2="results/trimmed/{sample}_R2.trimmed.fastq.gz",
        ref=config["reference"]["genome_fasta"]
    output:
        "results/bam/{sample}.sam"
    threads: config["alignment"]["bwa_threads"]
    conda:
        "../envs/alignment.yml"
    shell:
        "mkdir -p results/bam && bwa mem -t {threads} -R '@RG\\tID:{wildcards.sample}\\tSM:{wildcards.sample}\\tPL:ILLUMINA' {input.ref} {input.r1} {input.r2} > {output}"
