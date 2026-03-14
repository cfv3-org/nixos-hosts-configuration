{ pkgs, ... }:

{
#  virtualisation.oci-containers.containers.vllm = {
#    image = "vllm/vllm-openai-rocm:v0.15.1";
#    autoStart = true;
#
#    volumes = [
#      "vllm-cache:/root/.cache/huggingface"
#    ];
#
#    ports = ["11433:11433"];
#
#    extraOptions = [
#      "--device=/dev/kfd"
#      "--device=/dev/dri"
#      "--group-add=video"
#      "--security-opt=seccomp=unconfined"
#      "--ipc=host"
#    ];
#
#    cmd = [
#      "Qwen/Qwen2.5-Coder-7B-Instruct-AWQ"
#
#      "--host" "0.0.0.0"
#      "--port" "11433"
#
#      "--quantization" "awq"
#      "--gpu-memory-utilization" "0.85"
#      "--max-model-len" "16384"
#
#      "--enable-prefix-caching"
#      "--trust-remote-code"
#
#      "--served-model-name" "qwen-coder"
#      "--enable-auto-tool-choice"
#      "--tool-call-parser" "hermes"
#    ];
#  };
}
