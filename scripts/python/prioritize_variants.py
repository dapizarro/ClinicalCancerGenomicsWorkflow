#!/usr/bin/env python3
import argparse
from pathlib import Path
import pandas as pd

HIGH_IMPACT_CLINVAR = {"Pathogenic", "Likely_pathogenic", "Pathogenic/Likely_pathogenic"}

def score_variant(row, priority_genes):
    score=0
    if str(row.get("gene")) in priority_genes:
        score += 3
    if str(row.get("clinical_significance")) in HIGH_IMPACT_CLINVAR:
        score += 5
    try:
        af=float(row.get("gnomad_af", 0))
        if af <= 0.001:
            score += 1
        if af > 0.01:
            score -= 3
    except Exception:
        pass
    return score


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--annotated", required=True)
    ap.add_argument("--panel", required=True)
    ap.add_argument("--out", required=True)
    args=ap.parse_args()
    df=pd.read_csv(args.annotated, sep="\t")
    panel=pd.read_csv(args.panel, sep="\t")
    priority_genes=set(panel["gene"].astype(str))
    if df.empty:
        df["priority_score"]=[]
    else:
        df["priority_score"]=df.apply(lambda r: score_variant(r, priority_genes), axis=1)
        df["in_priority_panel"]=df["gene"].astype(str).isin(priority_genes)
        df=df.sort_values(["priority_score","gene"], ascending=[False, True])
    Path(args.out).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(args.out, sep="\t", index=False)

if __name__ == "__main__":
    main()
