{
  apiKey = "ollama-local";
  host = "0.0.0.0";
  port = 11434;
  primaryModel = "ollama/qwen3.5:9b";

  models = [
    {
      id = "ollama/qwen3.5:9b";
      fileName = "Qwen3.5-text-9B-Q4_K_M.gguf";
      url = "https://huggingface.co/techwithsergiu/Qwen3.5-text-9B-GGUF/resolve/main/Qwen3.5-text-9B-Q4_K_M.gguf";
      ctxSize = 8192;
    }
    {
      id = "ollama/gemma4:e4b";
      fileName = "gemma-4-E4B-it-Q4_K_M.gguf";
      url = "https://huggingface.co/unsloth/gemma-4-E4B-it-GGUF/resolve/main/gemma-4-E4B-it-Q4_K_M.gguf";
      ctxSize = 8192;
    }
  ];
}
