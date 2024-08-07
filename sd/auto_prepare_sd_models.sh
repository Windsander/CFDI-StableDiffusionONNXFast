#!/usr/bin/bash

# for Mac temp files cleaning
find . -name "._*" -type f -print
find . -name "._*" -type f -delete

# Default values for command line options
auto_confirm=""

# Parse command line options
while getopts ":nyc" opt; do
  case $opt in
    n)
      auto_confirm="no"
      ;;
    y)
      auto_confirm="yes"
      ;;
    c)
      auto_confirm="cancel"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Function to display the confirmation prompt
confirm() {
  echo "Parsing input params..."
  if [ "$auto_confirm" == "yes" ]; then
    return 0
  elif [ "$auto_confirm" == "no" ]; then
    return 1
  elif [ "$auto_confirm" == "cancel" ]; then
    echo "CANCELED..."
    exit
  fi

  echo "WARNING: to prepare safetensors_2_onnx converter env,
                 this cli-tool needs to force reinstalling all necessary pack,
                 from conda to current-conda-env's pip state."
  echo "IT'S A High-Risk Operation! be careful you choose."

  while true; do
    read -r -p "Ops: yes no [y/n] or cancel [c] ?" yn
    case $yn in
      [Yy]*) return 0 ;;
      [Nn]*) return 1 ;;
      [Cc]*)
        echo "CANCELED..."
        exit
        ;;
      *) echo "Please answer YES, NO, or CANCEL." ;;
    esac
  done
}

env_skipped() {
  echo "Skip converter environment security..."
  echo "Try to convert without env_check..."
}

env_prepare() {
  echo "Installing converter environment..."

  conda uninstall safetensors transformers diffusers
  conda uninstall torch torchaudio torchvision
  conda uninstall llvm-openmp intel-openmp
  conda uninstall pyarrow pillow image

  pip install pip_search

  conda install nomkl
  conda install numpy scipy pandas tensorflow
  pip install regex protobuf
  pip install pyarrow pillow image
  pip install numpy scipy pandas tensorflow
  pip install torch==2.2.0 torchaudio==2.2.0 torchvision==0.17.0
  pip install safetensors transformers==4.40.0 diffusers
  pip install optimum

  echo "Installed..."
}

# Function: Auto convert Stable Diffusion models
auto_convert_sd() {
  echo "===========================Auto converting start==========================="
  optimum-cli export onnx --model runwayml/stable-diffusion-v1-5 sd-base-model/onnx-sd-v15/
  optimum-cli export onnx --model stabilityai/sd-turbo sd-base-model/onnx-sd-turbo/
  echo "===========================Auto converting done.==========================="
}

# Function: Auto download Stable Diffusion models
auto_download_sd() {
  echo "========================Auto cloning official start========================"

  # Check if the onnx-official-sd-v15 directory exists
  if [ -d "sd-base-model/onnx-official-sd-v15" ]; then
    echo "Directory onnx-official-sd-v15 already exists. Skipping clone."
  else
    git clone https://huggingface.co/runwayml/stable-diffusion-v1-5 -b onnx sd-base-model/onnx-official-sd-v15/
  fi

  # Check if the onnx-sd-turbo directory exists
  if [ -d "sd-base-model/onnx-sd-v15" ]; then
    echo "Directory onnx-sd-v15 already exists. Skipping clone."
  else
    git clone https://huggingface.co/Windsander/onnx-sd-v15 sd-base-model/onnx-sd-v15/
  fi

  # Check if the onnx-sd-turbo directory exists
  if [ -d "sd-base-model/onnx-sd-turbo" ]; then
    echo "Directory onnx-sd-turbo already exists. Skipping clone."
  else
    git clone https://huggingface.co/Windsander/onnx-sd-turbo sd-base-model/onnx-sd-turbo/
  fi

  echo "========================Auto cloning official done.========================"
}

# do script
if confirm; then
  env_prepare
  auto_convert_sd
else
  env_skipped
  auto_download_sd
fi
