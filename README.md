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

This will automatically download model weights from HuggingFace (`geyongtao/gvm`) during the build process.

```bash
docker build -t gvm-image .
```

**Run interactively with GPU:**

```bash
# Use specific GPU (e.g., GPU 7)
docker run --gpus '"device=7"' --name gvm-container -it --rm \
  -v $(pwd)/data:/workspace/gvm/data \
  -v $(pwd)/output:/workspace/gvm/output \
  gvm-image bash
```

Inside the container, the model weights are already downloaded at `data/weights/`.

**GPU Selection Options:**

```bash
--gpus '"device=0"'      # Specific GPU by ID
--gpus '"device=0,1"'    # Multiple GPUs
--gpus all               # All GPUs
--gpus all -e CUDA_VISIBLE_DEVICES=7  # All GPUs, use specific one
```



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
