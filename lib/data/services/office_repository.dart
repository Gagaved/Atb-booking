import 'dart:async';

import '../models/level_plan.dart';
import '../models/office.dart';
import 'office_provider.dart';

class OfficeRepository {
  static final OfficeRepository _singleton = OfficeRepository._internal();
  factory OfficeRepository() {
    return _singleton;
  }
  OfficeRepository._internal();

  final OfficeProvider _officeProvider = OfficeProvider();

  Future<List<Office>> getOfficesByCityId(int id) =>
      _officeProvider.getOfficesByCityId(id);

  //Future<Office> getOfficeById(int id) => _officeProvider.getOfficeById(id);

  Future<List<LevelListItem>> getLevelsByOfficeId(int id) =>
      _officeProvider.getLevelsByOfficeId(id);
}
