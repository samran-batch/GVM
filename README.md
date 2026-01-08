<div align="center">
<div style="text-align: center;">
    <h1>Generative Video Matting</h1>
</div>


##  📖 Table of Contents

- [Generative Video Matting](#-generative-video-matting)
  - [🚀 Getting Started](#-getting-started)
    - [Project Setup 🐳](#project-setup-)
  - [🏃🏼 Run](#-run)
    - [Docker Inference 🐳](#docker-inference-)
  - [🎫 License](#-license)
  - [📢 Disclaimer](#-disclaimer)
  - [🤝 Cite Us](#-cite-us)



## 🚀 Getting Started

### Project Setup 🐳

First, clone the repo:

```bash
git clone https://github.com/samran-batch/GVM.git
cd GVM
```

**Build the Docker image:**

```bash
docker build -t gvm-image .
```

**Download model weights (one-time setup):**

Run this once to download weights to your local `data/weights/` folder. They will persist for future use.

```bash
docker run --gpus '"device=7"' --rm \
  -v $(pwd)/data:/workspace/gvm/data \
  gvm-image huggingface-cli download geyongtao/gvm --local-dir data/weights
```

**Run interactively with GPU:**

```bash
# Use specific GPU (e.g., GPU 7)
docker run --gpus '"device=7"' --name gvm-container -it --rm \
  -v $(pwd)/data:/workspace/gvm/data \
  -v $(pwd)/output:/workspace/gvm/output \
  gvm-image bash
```

The model weights are stored in your local `data/weights/` directory and mounted into the container.

**GPU Selection Options:**

| Command | Description |
|---------|-------------|
| `--gpus '"device=7"'` | Use GPU 7 |
| `--gpus '"device=0,1"'` | Use GPUs 0 and 1 |
| `--gpus all` | Use all GPUs |



## 🏃🏼 Run

### Docker Inference 🐳

Place your video file in the `data/demo_videos/` directory, then run:

```bash
# Using specific GPU (e.g., GPU 7)
docker run --gpus '"device=7"' --name gvm-container --rm \
  -v $(pwd)/data:/workspace/gvm/data \
  -v $(pwd)/output:/workspace/gvm/output \
  gvm-image python demo.py \
  --model_base data/weights/ \
  --unet_base data/weights/unet \
  --lora_base data/weights/unet \
  --mode matte \
  --num_frames_per_batch 8 \
  --num_interp_frames 1 \
  --num_overlap_frames 1 \
  --denoise_steps 1 \
  --decode_chunk_size 8 \
  --max_resolution 960 \
  --pretrain_type svd \
  --data_dir data/demo_videos/video.mp4 \
  --output_dir output
```

**Note:** Replace `video.mp4` with your actual video filename.

**Output:** Results will be saved in the `output/` directory on your host machine.
