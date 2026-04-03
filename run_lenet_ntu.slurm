#!/bin/bash
#SBATCH -A mfk-gsr2
#SBATCH -J sensefi_lenet_ntu
#SBATCH -p ISP
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH -t 08:00:00
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

if [ ! -d "Data/NTU-Fi_HAR/train_amp" ] || [ ! -d "Data/NTU-Fi_HAR/test_amp" ]; then
    echo "Error: Data/NTU-Fi_HAR/train_amp or Data/NTU-Fi_HAR/test_amp is missing."
    exit 1
fi

echo "Running: LeNet + NTU-Fi_HAR"
.venv/bin/python run.py --model LeNet --dataset NTU-Fi_HAR
echo "End Time: $(date)"
