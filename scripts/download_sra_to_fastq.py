import subprocess
import time
import os

# List of SRR IDs
sra_numbers = [
    "SRR7179504", "SRR7179505", "SRR7179506", "SRR7179507",
    "SRR7179508", "SRR7179509", "SRR7179510", "SRR7179511",
    "SRR7179520", "SRR7179521", "SRR7179522", "SRR7179523",
    "SRR7179524", "SRR7179525", "SRR7179526", "SRR7179527",
    "SRR7179536", "SRR7179537", "SRR7179540", "SRR7179541"
]

BASE_DIR = os.path.expanduser("~/Bulk_RNA_Seq")
RAW_DIR = os.path.join(BASE_DIR, "data/raw")
FASTQ_DIR = os.path.join(BASE_DIR, "fastq")

os.makedirs(RAW_DIR, exist_ok=True)
os.makedirs(FASTQ_DIR, exist_ok=True)

print("🚀 Starting SRA download and FASTQ conversion")

# ------------------ PREFETCH ------------------
for sra_id in sra_numbers:
    print(f"\n📥 Downloading {sra_id}")
    start = time.time()

    cmd = f"prefetch {sra_id} --output-directory {RAW_DIR}"
    subprocess.run(cmd, shell=True, check=True)

    mins = (time.time() - start) / 60
    print(f"✅ {sra_id} downloaded in {mins:.2f} minutes")

# ------------------ FASTQ DUMP ------------------
for sra_id in sra_numbers:
    sra_path = f"{RAW_DIR}/{sra_id}/{sra_id}.sra"

    print(f"\n🧬 Converting {sra_id} to FASTQ")
    start = time.time()

    cmd = (
        f"fastq-dump --outdir {FASTQ_DIR} --gzip "
        f"--skip-technical --readids --read-filter pass "
        f"--dumpbase --split-3 --clip {sra_path}"
    )

    subprocess.run(cmd, shell=True, check=True)

    mins = (time.time() - start) / 60
    print(f"🎉 {sra_id} FASTQ ready in {mins:.2f} minutes")

print("\n🏁 ALL DOWNLOADS AND CONVERSIONS COMPLETE")
