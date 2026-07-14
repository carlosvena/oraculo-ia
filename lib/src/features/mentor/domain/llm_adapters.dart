/// Interfaz desacoplada para integrar proveedores de IA en el futuro.
abstract interface class LlmentorAdapter {
  String get providerName;
  Future<String> requestExplanation({
    required String concept,
    required String style,
    required String learnerContext,
  });
}

/// Adaptador para la API de OpenAI.
final class OpenAiAdapter implements LlmentorAdapter {
  const OpenAiAdapter();

  @override
  String get providerName => 'OpenAI';

  @override
  Future<String> requestExplanation({
    required String concept,
    required String style,
    required String learnerContext,
  }) async {
    // Simula una llamada remota estructurada de OpenAI
    return '[OpenAI Response] Concepto: $concept. Estilo: $style. Contexto del alumno: $learnerContext. Explicación simulada de GPT.';
  }
}

/// Adaptador para la API de Gemini (Google).
final class GeminiAdapter implements LlmentorAdapter {
  const GeminiAdapter();

  @override
  String get providerName => 'Gemini';

  @override
  Future<String> requestExplanation({
    required String concept,
    required String style,
    required String learnerContext,
  }) async {
    // Simula una llamada remota estructurada de Gemini (multimodal/instrucciones del sistema)
    return '[Gemini Response] Concepto: $concept. Estilo: $style. Contexto del alumno: $learnerContext. Explicación simulada de Gemini Flash/Pro.';
  }
}

/// Adaptador para la API de Claude (Anthropic).
final class ClaudeAdapter implements LlmentorAdapter {
  const ClaudeAdapter();

  @override
  String get providerName => 'Claude';

  @override
  Future<String> requestExplanation({
    required String concept,
    required String style,
    required String learnerContext,
  }) async {
    return '[Claude Response] Concepto: $concept. Estilo: $style. Contexto del alumno: $learnerContext. Explicación detallada de Claude Sonnet.';
  }
}

/// Adaptador para la API de DeepSeek.
final class DeepSeekAdapter implements LlmentorAdapter {
  const DeepSeekAdapter();

  @override
  String get providerName => 'DeepSeek';

  @override
  Future<String> requestExplanation({
    required String concept,
    required String style,
    required String learnerContext,
  }) async {
    return '[DeepSeek Response] Concepto: $concept. Estilo: $style. Contexto del alumno: $learnerContext. Razonamiento profundo de DeepSeek R1.';
  }
}

/// Adaptador para la API de Qwen.
final class QwenAdapter implements LlmentorAdapter {
  const QwenAdapter();

  @override
  String get providerName => 'Qwen';

  @override
  Future<String> requestExplanation({
    required String concept,
    required String style,
    required String learnerContext,
  }) async {
    return '[Qwen Response] Concepto: $concept. Estilo: $style. Contexto: $learnerContext. Explicación de Qwen Coder.';
  }
}

/// Adaptador para la API de GLM (Zhipu).
final class GlmAdapter implements LlmentorAdapter {
  const GlmAdapter();

  @override
  String get providerName => 'GLM';

  @override
  Future<String> requestExplanation({
    required String concept,
    required String style,
    required String learnerContext,
  }) async {
    return '[GLM Response] Concepto: $concept. Estilo: $style. Contexto: $learnerContext. Explicación de GLM-4.';
  }
}

/// Adaptador para la API de Llama (Meta).
final class LlamaAdapter implements LlmentorAdapter {
  const LlamaAdapter();

  @override
  String get providerName => 'Llama';

  @override
  Future<String> requestExplanation({
    required String concept,
    required String style,
    required String learnerContext,
  }) async {
    return '[Llama Response] Concepto: $concept. Estilo: $style. Contexto: $learnerContext. Explicación de Llama-3.1.';
  }
}

/// Adaptador para la API de Mistral.
final class MistralAdapter implements LlmentorAdapter {
  const MistralAdapter();

  @override
  String get providerName => 'Mistral';

  @override
  Future<String> requestExplanation({
    required String concept,
    required String style,
    required String learnerContext,
  }) async {
    return '[Mistral Response] Concepto: $concept. Estilo: $style. Contexto: $learnerContext. Explicación de Mistral Large.';
  }
}
