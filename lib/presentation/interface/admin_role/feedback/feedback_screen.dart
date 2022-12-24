import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/admin_role/feedback/admin_feedback_bloc.dart';
import 'package:atb_booking/presentation/interface/admin_role/feedback/feedback_card.dart';
import 'package:atb_booking/presentation/interface/auth/auth_screen.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminFeedbackScreen extends StatelessWidget {
  const AdminFeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Обратная связь"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Auth()));
                NetworkController()
                    .exitFromApp(); //todo вынести в блок как эвент и ждать
              },
              icon: const Icon(Icons.logout, size: 28))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Text(
              'Тип обратной связи',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.w300),
            ),
          ),
          _DropdownButtonType(),
          const SizedBox(height: 30),
          _ResultList(),
        ]),
      ),
    );
  }
}

class _DropdownButtonType extends StatelessWidget {
  const _DropdownButtonType();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminFeedbackBloc, AdminFeedbackState>(
      builder: (context, state) {
        if (state.typeId == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 238, 238),
                  borderRadius: BorderRadius.all(Radius.circular(10.0) //
                      ),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: Container(),
                  value: state.listType[0],
                  onChanged: (String? value) {
                    if (value == state.listType[1]) {
                      context
                          .read<AdminFeedbackBloc>()
                          .add(AdminFeedbackType_UserComplaintEvent());
                    } else if (value == state.listType[2]) {
                      context
                          .read<AdminFeedbackBloc>()
                          .add(AdminFeedbackType_WorkplaceComplaintEvent());
                    } else {
                      return;
                    }
                  },
                  items: state.listType
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        } else if (state.typeId == 2) {
          return Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 238, 238),
                  borderRadius: BorderRadius.all(Radius.circular(10.0) //
                      ),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: Container(),
                  value: state.listType[1],
                  onChanged: (String? value) {
                    if (value == state.listType[0]) {
                      context
                          .read<AdminFeedbackBloc>()
                          .add(AdminFeedbackType_ApplicationMessageEvent());
                    } else if (value == state.listType[2]) {
                      context
                          .read<AdminFeedbackBloc>()
                          .add(AdminFeedbackType_WorkplaceComplaintEvent());
                    } else {
                      return;
                    }
                  },
                  items: state.listType
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 238, 238),
                  borderRadius: BorderRadius.all(Radius.circular(10.0) //
                      ),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: Container(),
                  value: state.listType[2],
                  onChanged: (String? value) {
                    if (value == state.listType[0]) {
                      context
                          .read<AdminFeedbackBloc>()
                          .add(AdminFeedbackType_ApplicationMessageEvent());
                    } else if (value == state.listType[1]) {
                      context
                          .read<AdminFeedbackBloc>()
                          .add(AdminFeedbackType_UserComplaintEvent());
                    } else {
                      return;
                    }
                  },
                  items: state.listType
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class _ResultList extends StatelessWidget {
  _ResultList();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        context.read<AdminFeedbackBloc>().add(AdminFeedbackLoadNextPageEvent());
      }
    });

    return Expanded(
      child: BlocConsumer<AdminFeedbackBloc, AdminFeedbackState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is AdminFeedbackErrorState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    'Ой...  Не удалось загрузить.\n Попробуйте еще раз...',
                    style: TextStyle(fontSize: 25)),
                const SizedBox(height: 40),
                AtbElevatedButton(
                    onPressed: () {
                      if (state.typeId == 1) {
                        context
                            .read<AdminFeedbackBloc>()
                            .add(AdminFeedbackType_ApplicationMessageEvent());
                      } else if (state.typeId == 2) {
                        context
                            .read<AdminFeedbackBloc>()
                            .add(AdminFeedbackType_UserComplaintEvent());
                      } else if (state.typeId == 3) {
                        context
                            .read<AdminFeedbackBloc>()
                            .add(AdminFeedbackType_WorkplaceComplaintEvent());
                      } else {
                        return;
                      }
                    },
                    text: "Загрузить")
              ],
            ));
          } else if (state is AdminFeedbackMainState ||
              state is AdminFeedbackLoadingState) {
            if (state is AdminFeedbackLoadingState &&
                state.formHasBeenChanged) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.feedbackListItems.isEmpty) {
              return const Center(
                child: Text("Ничего не найдено"),
              );
            } else {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.feedbackListItems.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      FeedbackCard(state.feedbackListItems[index]),
                      (state is AdminFeedbackLoadingState &&
                              index == state.feedbackListItems.length - 1)
                          ? Container(
                              height: 150,
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ))
                          : const SizedBox.shrink(),
                    ],
                  );
                },
              );
            }
          } else {
            throw Exception('bad state into adminFeedback: $state');
          }
        },
      ),
    );
  }
}
