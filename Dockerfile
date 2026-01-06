FROM nvidia/cuda:13.0.0-cudnn-devel-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive
# Blackwell GPU (sm_120) - RTX PRO 6000
# https://developer.nvidia.com/cuda-gpus
ENV TORCH_CUDA_ARCH_LIST="12.0"

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

WORKDIR /workspace/gvm

# Default command to show help
CMD ["python", "demo.py", "--help"]
