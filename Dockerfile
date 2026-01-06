FROM nvidia/cuda:13.0.0-cudnn-devel-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG NO_ALBUMENTATIONS_UPDATE=1
# update it according to your GPU
# https://developer.nvidia.com/cuda-gpus
# Blackwell sm_120 supported via PyTorch 2.9.1+cu130
ARG TORCH_CUDA_ARCH_LIST="8.0;8.6;8.9;12.0+PTX"

# Install Python 3.11 and system dependencies
RUN apt update -y && apt install -y \
  python3.11 python3.11-dev python3.11-venv python3-pip \
  git vim wget htop libgl1 libglib2.0-0 curl \
  ffmpeg pkg-config libavformat-dev libavcodec-dev libavdevice-dev \
  libavutil-dev libswscale-dev libswresample-dev libavfilter-dev && \
  update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
  update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 && \
  python3 -m pip install --upgrade pip && \
  apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Install PyTorch 2.9.1 with CUDA 13.0 support (works with Blackwell sm_120)
RUN pip install torch==2.9.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130

# Copy project files
COPY . /workspace/gvm/

WORKDIR /workspace/gvm

# Install project dependencies
RUN pip install -r requirements.txt && \
  python setup.py develop

# Install huggingface_hub (weights will be mounted at runtime)
RUN pip install huggingface_hub

# Create necessary directories (weights will be mounted from host)
RUN mkdir -p data/datasets data/demo_videos data/weights

WORKDIR /workspace/gvm

# Default command to show help
CMD ["python", "demo.py", "--help"]
