rule fastqc_raw:
    input:
        r1=lambda wildcards: samples.loc[samples.sample_id == wildcards.sample, "fastq_r1"].values[0],
        r2=lambda wildcards: samples.loc[samples.sample_id == wildcards.sample, "fastq_r2"].values[0]
    output:
        html1="results/qc/fastqc/{sample}_R1_fastqc.html",
        html2="results/qc/fastqc/{sample}_R2_fastqc.html"
    conda:
        "../envs/qc.yml"
    shell:
        "mkdir -p results/qc/fastqc && fastqc {input.r1} {input.r2} -o results/qc/fastqc"

rule multiqc:
    input:
        expand("results/qc/fastqc/{sample}_R1_fastqc.html", sample=SAMPLES),
        expand("results/qc/fastqc/{sample}_R2_fastqc.html", sample=SAMPLES)
    output:
        "results/qc/multiqc_report.html"
    conda:
        "../envs/qc.yml"
    shell:
        "multiqc results/qc -o results/qc"
