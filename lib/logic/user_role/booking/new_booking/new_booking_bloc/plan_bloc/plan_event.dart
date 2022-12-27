part of 'plan_bloc.dart';

@immutable
abstract class PlanEvent {}
class PlanTapElementEvent extends PlanEvent{
  final LevelPlanElementData workspace;

  PlanTapElementEvent(this.workspace);
}
class PlanLoadEvent extends PlanEvent{
  final int levelId;
  final int maxBookingRangeInDays;
  PlanLoadEvent(this.levelId, this.maxBookingRangeInDays);
}
class PlanClearTitleEvent extends PlanEvent{}
class PlanHideEvent extends PlanEvent{}

class PlanSelectDateEvent extends PlanEvent{
  final DateTime dateTime;
  PlanSelectDateEvent(this.dateTime);

}