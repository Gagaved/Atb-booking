import 'dart:async';
import '../models/level_plan.dart';
import '../models/office.dart';
import 'office_provider.dart';

class OfficeRepository {
  final OfficeProvider _officeProvider = OfficeProvider();

  Future<List<OfficeListItem>> getOfficesByCityId(int id) =>
      _officeProvider.getOfficesByCityId(id);

  Future<Office> getOfficeById(int id) => _officeProvider.getOfficeById(id);

  Future<List<Level>> getLevelsByOfficeId(int id) =>
      _officeProvider.getLevelsByOfficeId(id);
}
