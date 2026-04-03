#!/bin/bash
#SBATCH -A mfk-gsr2
#SBATCH -J sensefi_widar_gpu
#SBATCH -p plcyf-gpu
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --gres=gpu:1
#SBATCH -t 24:00:00
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

if [ ! -d "Data/Widardata/train" ] || [ ! -d "Data/Widardata/test" ]; then
    echo "Error: Data/Widardata/train or Data/Widardata/test is missing."
    exit 1
fi

if command -v nvidia-smi >/dev/null 2>&1; then
    echo "GPU Info:"
    nvidia-smi
fi

echo "Running on GPU partition: MLP + Widar"
.venv/bin/python -u run.py --model MLP --dataset Widar
echo "End Time: $(date)"
