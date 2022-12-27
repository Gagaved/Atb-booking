import 'workspace.dart';

class LevelListItem {
  final int id;
  final int number;

  LevelListItem({required this.id, required this.number});

  LevelListItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        number = json['number'];
}

class Level {
  final int id;
  final int number;
  final int? planId;
  final List<LevelPlanElementData> workspaces;

  Level({required this.id, required this.number,required this.planId, required this.workspaces});

  Level.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        planId = json['planId'],
        number = json['number'],
        workspaces = (json['workspaces'] as List<dynamic>)
            .map((json) => LevelPlanElementData.fromJson(json))
            .toList();

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};
    //json['id'] = id;
    json["number"] = number;
    json["planId"] = planId;
    return json;
  }
}

