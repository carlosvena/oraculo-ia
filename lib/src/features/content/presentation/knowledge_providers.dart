import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_reader.dart';
import 'package:oraculo_ia/src/features/content/domain/knowledge_content.dart';

final knowledgeProvider = FutureProvider<KnowledgeContent>(
  (ref) => const KnowledgeReader().load(),
);
