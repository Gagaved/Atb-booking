import 'package:atb_booking/data/models/feedback.dart';
import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/users_provider.dart';
import 'package:atb_booking/data/services/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'feedback_open_card_event.dart';
part 'feedback_open_card_state.dart';

class FeedbackOpenCardBloc
    extends Bloc<FeedbackOpenCardEvent, FeedbackOpenCardState> {
  final FeedbackItem feedback;
  User? user;
  User? complaint;

  FeedbackOpenCardBloc(this.feedback) : super(FeedbackOpenCardLoadingState()) {
    on<FeedbackOpenCardLoadEvent>((event, emit) async {
      emit(FeedbackOpenCardLoadingState());
      try {
        user = await UsersRepository().getUserById(feedback.userId);
        if (feedback.guiltyId != null) {
          complaint = await UsersRepository().getUserById(feedback.guiltyId!);
        }
        emit(FeedbackOpenCardLoadedState(feedback, user!, complaint));
      } catch (_) {
        emit(FeedbackOpenCardErrorState());
      }
    });
    add(FeedbackOpenCardLoadEvent());
  }
}
