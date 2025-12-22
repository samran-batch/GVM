<div align="center">
<div style="text-align: center;">
    <h1>Generative Video Matting</h1>
</div>

**SIGGRAPH2025**

<p align="center">
<a href='https://yongtaoge.github.io/project/gvm'><img src='https://img.shields.io/badge/Project-Page-Green'></a> &nbsp;
<a href="https://arxiv.org/abs/2508.07905"><img src="https://img.shields.io/badge/arXiv-2508.07905-b31b1b.svg"></a> &nbsp;
<a href="https://github.com/aim-uofa/GVM"><img src="https://img.shields.io/badge/GitHub-Code-black?logo=github"></a> &nbsp;
<a href='https://huggingface.co/datasets/geyongtao/SynHairMan'><img src='https://img.shields.io/badge/%F0%9F%A4%97%20Hugging%20Face-Dataset-blue'></a> &nbsp;
<a href="https://huggingface.co/geyongtao/gvm"><img src="https://img.shields.io/badge/%F0%9F%A4%97%20Hugging%20Face-Model-blue"></a>
</p>

</div>


##  📖 Table of Contents

- [Generative Video Matting](#-generative-video-matting)
  - [🔥 News](#-news)
  - [🚀 Getting Started](#-getting-started)
    - [Docker Setup 🐳](#docker-setup-)
  - [🏃🏼 Run](#-run)
    - [Docker Inference 🐳](#docker-inference-)
  - [🎫 License](#-license)
  - [📢 Disclaimer](#-disclaimer)
  - [🤝 Cite Us](#-cite-us)



## 🚀 Getting Started

### Docker Setup 🐳

First, clone the repo:

```bash
https://github.com/samran-batch/GVM.git
cd GVM
```

**Build the Docker image:**

This will automatically download model weights from HuggingFace (`geyongtao/gvm`) during the build process.

```bash
docker build -t gvm-image .
```

**Run interactively:**
```bash
docker run --name gvm-container -it --rm \
  -v $(pwd)/data:/workspace/gvm/data \
  -v $(pwd)/output:/workspace/gvm/output \
  gvm-image bash
```

Inside the container, the model weights are already downloaded at `data/weights/`.



## 🏃🏼 Run

### Docker Inference 🐳

Place your video file in the `data/demo_videos/` directory, then run:

```bash
docker run --name gvm-container --rm \
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
