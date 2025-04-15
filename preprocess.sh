#!/bin/bash

# 使用範例:
# ./preprocess_scene.sh /path/to/your/scene

# 檢查輸入參數
if [ $# -ne 1 ]; then
    echo "用法: $0 <SCENE_DIR>"
    exit 1
fi

SCENE_DIR=$1


# 抓取當前 Python 執行路徑 (無論是 conda 或 virtualenv)
PYTHON_EXEC=$(which python)
echo "=== 使用 Python: ${PYTHON_EXEC} ==="


echo "=== 開始處理場景: $SCENE_DIR ==="

# 1. 生成深度圖 (DPT)
echo "[1/3] 生成 DPT 深度圖..."
python scripts/generate_DPT.py \
    --dataset_path "${SCENE_DIR}" \
    --model weights/dpt_large-midas-2f21e586.pt

# 2. 生成光流 (RAFT)
echo "[2/3] 生成 RAFT 光流..."
python scripts/generate_flow.py \
    --dataset_path "${SCENE_DIR}" \
    --model weights/raft-things.pth

# 3. 生成 Mask
echo "[3/3] 生成 Mask..."
python scripts/generate_mask.py \
    --dataset_path "${SCENE_DIR}"

echo "=== 完成！ ==="