FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

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

# Install PyTorch CPU version
RUN pip install torch==2.6.0 torchvision==0.21.0 torchaudio --index-url https://download.pytorch.org/whl/cpu

# Copy project files
COPY . /workspace/gvm/

WORKDIR /workspace/gvm

# Install project dependencies
RUN pip install -r requirements.txt && \
  python setup.py develop

# Download GVM model weights
RUN pip install huggingface_hub && \
  huggingface-cli download geyongtao/gvm --local-dir data/weights

# Create necessary directories
RUN mkdir -p data/datasets data/demo_videos

WORKDIR /workspace/gvm

# Default command to show help
CMD ["python", "demo.py", "--help"]
