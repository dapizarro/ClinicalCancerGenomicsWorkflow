rule fastp:
    input:
        r1=lambda wildcards: samples.loc[samples.sample_id == wildcards.sample, "fastq_r1"].values[0],
        r2=lambda wildcards: samples.loc[samples.sample_id == wildcards.sample, "fastq_r2"].values[0]
    output:
        r1="results/trimmed/{sample}_R1.trimmed.fastq.gz",
        r2="results/trimmed/{sample}_R2.trimmed.fastq.gz",
        html="results/qc/fastp/{sample}.fastp.html",
        json="results/qc/fastp/{sample}.fastp.json"
    conda:
        "../envs/qc.yml"
    shell:
        "mkdir -p results/trimmed results/qc/fastp && fastp -i {input.r1} -I {input.r2} -o {output.r1} -O {output.r2} -h {output.html} -j {output.json}"
