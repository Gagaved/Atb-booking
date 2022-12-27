import '../models/level_plan.dart';
import 'level_plan_provider.dart';

class LevelPlanRepository {
  final LevelProvider _levelPlanProvider = LevelProvider();
  Future<Level> getPlanByLevelId(int id) => _levelPlanProvider.getPlanByLevelId(id);
}
