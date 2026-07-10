final class Mission {
  Mission({
    required this.id,
    required this.contentVersion,
    required this.lessonId,
    required this.title,
    required this.estimatedMinutes,
    required this.sequence,
    required List<String> prerequisiteIds,
  }) : prerequisiteIds = List<String>.unmodifiable(prerequisiteIds);

  final String id;
  final int contentVersion;
  final String lessonId;
  final String title;
  final int estimatedMinutes;
  final int sequence;
  final List<String> prerequisiteIds;
}
