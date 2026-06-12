from pathlib import Path

REQUIRED = [
    "README.md",
    "environment.yml",
    "config/config.yaml",
    "workflow/Snakefile",
    "scripts/python/annotate_variants.py",
    "scripts/python/prioritize_variants.py",
    "scripts/R/survival_analysis.R",
]

def test_required_files_exist():
    root = Path(__file__).resolve().parents[1]
    for rel in REQUIRED:
        assert (root / rel).exists(), rel
