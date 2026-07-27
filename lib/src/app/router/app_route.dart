import 'package:oraculo_ia/src/features/missions/domain/mission.dart';

abstract final class AppRoute {
  static const splash = '/';
  static const welcome = '/welcome';
  static const mission = '/mission';
  static const lesson = '/lesson';
  static const progress = '/progress';
  static const manual = '/manual';
  static const dictionary = '/dictionary';
  static const catalog = '/catalog';
  static const thoughts = '/thoughts';
  static const promptLab = '/prompt-lab';
  static const knowledgeMap = '/knowledge-map';
  static const about = '/about';
  static const backup = '/backup';
  static const modelComparator = '/model-comparator';
  static const learnerProfile = '/learner-profile';
  static const assessment = '/assessment';
  static const review = '/review';
  static const editorial = '/editorial';
  static const manualExport = '/manual-export';
  static const projects = '/projects';
  static const career = '/career';

  static String lessonFor(Mission mission) {
    return '$lesson/${mission.id}/${mission.lessonId}';
  }
}
