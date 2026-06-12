#!/usr/bin/env python3
"""Annotate a VCF with minimal ClinVar and population-frequency TSV tables.

This script is intentionally lightweight so the repository can run in restricted
environments. In production, replace or complement this step with VEP, ANNOVAR,
SnpEff, CIViC, COSMIC or institutional clinical annotation resources.
"""
import argparse, gzip
from pathlib import Path
import pandas as pd


def open_text(path):
    return gzip.open(path, "rt") if str(path).endswith(".gz") else open(path)


def parse_vcf(vcf, sample):
    rows=[]
    with open_text(vcf) as handle:
        for line in handle:
            if line.startswith("#"):
                continue
            chrom,pos,vid,ref,alt,qual,flt,info,*rest=line.rstrip().split("\t")
            info_dict={}
            for item in info.split(";"):
                if "=" in item:
                    k,v=item.split("=",1); info_dict[k]=v
            rows.append({
                "sample_id": sample,
                "chrom": chrom,
                "pos": int(pos),
                "ref": ref,
                "alt": alt.split(",")[0],
                "qual": qual,
                "filter": flt,
                "depth": info_dict.get("DP", "NA"),
            })
    return pd.DataFrame(rows)


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--vcf", required=True)
    ap.add_argument("--clinvar", required=True)
    ap.add_argument("--population", required=True)
    ap.add_argument("--sample", required=True)
    ap.add_argument("--out", required=True)
    args=ap.parse_args()

    variants=parse_vcf(args.vcf, args.sample)
    if variants.empty:
        variants=pd.DataFrame(columns=["sample_id","chrom","pos","ref","alt","qual","filter","depth"])

    clinvar=pd.read_csv(args.clinvar, sep="\t")
    pop=pd.read_csv(args.population, sep="\t")
    for df in (clinvar, pop):
        df["chrom"]=df["chrom"].astype(str)
        df["pos"]=df["pos"].astype(int)
    variants["chrom"]=variants["chrom"].astype(str)

    out=variants.merge(clinvar, on=["chrom","pos","ref","alt"], how="left")
    out=out.merge(pop, on=["chrom","pos","ref","alt"], how="left")
    out["clinical_significance"]=out["clinical_significance"].fillna("Uncertain_or_not_in_ClinVar")
    out["gene"]=out["gene"].fillna("NA")
    out["gnomad_af"]=out["gnomad_af"].fillna(0)
    Path(args.out).parent.mkdir(parents=True, exist_ok=True)
    out.to_csv(args.out, sep="\t", index=False)

if __name__ == "__main__":
    main()
