FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl aria2 ca-certificates libgl1 libglib2.0-0 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
ARG COMFY=8f40b43e0204d5b9780f3e9618e140e929e80594
RUN git clone https://github.com/comfyanonymous/ComfyUI.git \
 && cd ComfyUI && git checkout $COMFY

WORKDIR /opt/ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p models/checkpoints models/controlnet models/loras output

COPY start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

EXPOSE 8188
CMD ["/opt/start.sh"]
