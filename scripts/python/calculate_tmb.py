#!/usr/bin/env python3
import argparse
from pathlib import Path
import pandas as pd

PATHOGENIC_LABELS={"Pathogenic","Likely_pathogenic","Pathogenic/Likely_pathogenic"}

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--variants", required=True, help="Directory containing *.prioritized.tsv")
    ap.add_argument("--samplesheet", required=True)
    ap.add_argument("--out", required=True)
    args=ap.parse_args()
    samples=pd.read_csv(args.samplesheet)
    rows=[]
    for _,s in samples.iterrows():
        sid=s.sample_id
        panel_mb=float(s.get("panel_mb", 1.0))
        f=Path(args.variants)/f"{sid}.prioritized.tsv"
        if f.exists() and f.stat().st_size > 0:
            df=pd.read_csv(f, sep="\t")
            if df.empty:
                eligible=0; brca1="WT_or_not_detected"; brca2="WT_or_not_detected"
            else:
                # In real clinical analyses, eligible variants should be restricted to somatic, coding, nonsynonymous calls.
                df["gnomad_af"]=pd.to_numeric(df.get("gnomad_af",0), errors="coerce").fillna(0)
                eligible=int((df["gnomad_af"] <= 0.01).sum())
                brca1="Mutated" if ((df.gene=="BRCA1") & (df.clinical_significance.isin(PATHOGENIC_LABELS))).any() else "WT_or_not_detected"
                brca2="Mutated" if ((df.gene=="BRCA2") & (df.clinical_significance.isin(PATHOGENIC_LABELS))).any() else "WT_or_not_detected"
        else:
            eligible=0; brca1="WT_or_not_detected"; brca2="WT_or_not_detected"
        tmb=eligible/panel_mb if panel_mb else 0
        rows.append({"sample_id":sid,"eligible_variants":eligible,"panel_mb":panel_mb,"tmb":tmb,"tmb_group":"High" if tmb>=10 else "Low","brca1_status":brca1,"brca2_status":brca2,"brca_status":"Mutated" if brca1=="Mutated" or brca2=="Mutated" else "WT_or_not_detected"})
    out=pd.DataFrame(rows)
    Path(args.out).parent.mkdir(parents=True, exist_ok=True)
    out.to_csv(args.out, sep="\t", index=False)

if __name__=="__main__": main()
