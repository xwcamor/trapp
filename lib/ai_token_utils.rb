require "tiktoken_ruby"

module AiTokenUtils
  MODELOS = {
    "gpt-4o"           => { input: 0.005,  output: 0.015 },
    "gpt-3.5-turbo"    => { input: 0.0005, output: 0.0015 },
    "gpt-4"            => { input: 0.01,   output: 0.03 }
  }

  def self.contar_tokens(prompt, model)
    encoder = Tiktoken.encoding_for_model(model)
    encoder.encode(prompt).length
  end

  def self.estimar_costo(prompt, model)
    precios = MODELOS[model]
    return 0 unless precios

    tokens = contar_tokens(prompt, model)
    input_tokens = tokens / 2.0
    output_tokens = tokens / 2.0

    total = (input_tokens * precios[:input] + output_tokens * precios[:output]) / 1000.0
    total.round(6)
  end
end
