class ModelProfile {
  const ModelProfile({required this.id, required this.name, required this.what, required this.strengths, required this.limits, required this.uses, required this.avoid, required this.privacy, required this.availability, required this.related, required this.source, required this.verified});
  final String id, name, what, avoid, privacy, availability, source;
  final List<String> strengths, limits, uses, related;
  final bool verified;
}
