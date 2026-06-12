#!/usr/bin/env python3
import argparse
from pathlib import Path
import pandas as pd

def group_tils(x, cutoff=20, high_if_ge=True):
    try: v=float(x)
    except Exception: return "Unknown"
    return "High" if v >= cutoff else "Low"

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--clinical", required=True)
    ap.add_argument("--immune", required=True)
    ap.add_argument("--tmb", required=True)
    ap.add_argument("--variants", required=True)
    ap.add_argument("--out", required=True)
    args=ap.parse_args()
    clinical=pd.read_csv(args.clinical)
    immune=pd.read_csv(args.immune)
    tmb=pd.read_csv(args.tmb, sep="\t")
    df=clinical.merge(immune,on="sample_id",how="left").merge(tmb,on="sample_id",how="left")
    df["cd8_intraepithelial_group"]=df["cd8_intraepithelial"].apply(group_tils)
    df["cd4_intraepithelial_group"]=df["cd4_intraepithelial"].apply(group_tils)
    df["cd8_cd4_ratio"]=pd.to_numeric(df["cd8_intraepithelial"], errors="coerce") / pd.to_numeric(df["cd4_intraepithelial"].replace(0, pd.NA), errors="coerce")
    df["pdl1_status"]=pd.to_numeric(df["pdl1_tps"], errors="coerce").fillna(0).apply(lambda x: "Positive" if x>=1 else "Negative")
    Path(args.out).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(args.out, sep="\t", index=False)

if __name__=="__main__": main()
