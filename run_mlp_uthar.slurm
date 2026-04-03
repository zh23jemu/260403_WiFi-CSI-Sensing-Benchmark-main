#!/bin/bash
#SBATCH -A mfk-gsr2
#SBATCH -J sensefi_mlp_ut
#SBATCH -p ISP
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH -t 02:00:00
#SBATCH -o logs/%x-%j.out
#SBATCH -e logs/%x-%j.err

set -euo pipefail

cd "$SLURM_SUBMIT_DIR"
mkdir -p logs

echo "Job ID: $SLURM_JOB_ID"
echo "Job Name: $SLURM_JOB_NAME"
echo "Node: $(hostname)"
echo "Start Time: $(date)"
echo "Working Dir: $(pwd)"

if [ ! -x ".venv/bin/python" ]; then
    echo "Error: .venv/bin/python does not exist or is not executable."
    exit 1
fi

if [ ! -d "Data/UT_HAR/data" ] || [ ! -d "Data/UT_HAR/label" ]; then
    echo "Error: Data/UT_HAR/data or Data/UT_HAR/label is missing."
    exit 1
fi

echo "Running: MLP + UT_HAR_data"
.venv/bin/python run.py --model MLP --dataset UT_HAR_data
echo "End Time: $(date)"
