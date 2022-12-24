import 'package:atb_booking/logic/user_role/feedback_bloc/complaint_bloc/complaint_bloc.dart';
import 'package:atb_booking/presentation/constants/styles.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackUserComplaint extends StatelessWidget {
  static final TextEditingController messageInputController =
      TextEditingController();

  const FeedbackUserComplaint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Обратная связь",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 45, left: 30, right: 30),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  /// Тип жалобы
                  _TitleComplaint(),
                  SizedBox(height: 40),

                  /// Поле для сообщения
                  _MessageField(),
                  SizedBox(height: 45),

                  /// Кнопка отправить
                  _Button(),
                  SizedBox(height: 10)
                ]),
          ),
        ),
      ),
    );
  }
}

class _TitleComplaint extends StatelessWidget {
  const _TitleComplaint();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplaintBloc, ComplaintState>(
      builder: (context, state) {
        /// Если экран загружен, пользователь получен
        if (state is ComplaintLoadedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Пожаловаться на:",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface, fontSize: 28),
              ),
              const SizedBox(height: 5),
              Text(
                state.userPerson.fullName,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith( fontSize: 23),
              ),
            ]),
          );
        }

        /// Во всех остальных состояниях
        else if (state is ComplaintErrorState) {
          return Container();
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Пожаловаться на:",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface, fontSize: 28),
              ),
              const SizedBox(height: 5),
            ]),
          );
        }
      },
    );
  }
}

class _MessageField extends StatelessWidget {
  const _MessageField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplaintBloc, ComplaintState>(
      builder: (context, state) {
        if (state is ComplaintLoadingState || state is ComplaintInitialState) {
          return const Center();
        } else if (state is ComplaintLoadedState) {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text("Сообщение",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                        fontSize: 24,
                        fontWeight: FontWeight.w300)

                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  onChanged: (form) {
                    context
                        .read<ComplaintBloc>()
                        .add(ComplaintMessageInputEvent(form));
                  },
                  controller: FeedbackUserComplaint.messageInputController,
                  decoration:
                      const InputDecoration(hintText: 'Введите текст \n\n'),
                  keyboardType: TextInputType.streetAddress,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 20),
                  maxLines: 20,
                  minLines: 1,
                  maxLength: 1000,
                ),
              )
            ],
          );
        } else if (state is ComplaintSuccessState) {
          /// Выход с экрана
          return const Center();
        } else if (state is ComplaintErrorState) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ой...  Не удалось загрузить.',
                  style: TextStyle(fontSize: 25)),
              SizedBox(height: 50),
              AtbElevatedButton(
                  onPressed: () {
                    context
                        .read<ComplaintBloc>()
                        .add(ComplaintStartingEvent(state.currentUser!));
                  },
                  text: "Попробовать еще раз")
            ],
          ));
        } else {
          return ErrorWidget(Exception("BadState Complaint"));
        }
      },
    );
  }
}

class _Button extends StatelessWidget {
  const _Button();

  void _submitButton(BuildContext popupContext) async {
    bool _exit = false;

    await showDialog(
        context: popupContext,
        builder: (context) {
          return BlocProvider<ComplaintBloc>.value(
            value: popupContext.read<ComplaintBloc>(),
            child: BlocBuilder<ComplaintBloc, ComplaintState>(
              builder: (popupContext, state) {
                print("state: ${state.toString()}");
                if (state is ComplaintLoadingState) {
                  return const AlertDialog(
                    title: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is ComplaintSuccessState) {
                  _exit = true;
                  return const AlertDialog(
                    title: Text(
                      "Сообщение отправлено",
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (state is ComplaintErrorState) {
                  return AlertDialog(
                    title: Text(
                      "Не удалось отправить сообщение",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: appThemeData.colorScheme.error),
                    ),
                  );
                }
                throw Exception('Bad State: $state');
              },
            ),
          );
        });
    if (_exit) {
      Navigator.pop(popupContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplaintBloc, ComplaintState>(
      builder: (context, state) {
        print("State into complaint: $state");
        if (state is ComplaintLoadedState) {
          if (state.showButton) {
            return Center(
              child: AtbElevatedButton(
                  onPressed: () {
                    context
                        .read<ComplaintBloc>()
                        .add(ComplaintSubmitEvent(state.userPerson.id));
                    _submitButton(context);
                    FeedbackUserComplaint.messageInputController.clear();
                  },
                  text: "Отправить"),
            );
          } else {
            FeedbackUserComplaint.messageInputController.clear();
            return Center(
                child: ElevatedButton(
              style: ButtonStyle(
                //backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              onPressed: () {},
              child: SizedBox(
                  width: 240,
                  height: 60,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "Отправить",
                          // style: Theme.of(context).textTheme.displayLarge
                          //     ?.copyWith(color: Colors.white, fontSize: 20),
                        )),
                      ],
                    ),
                  )),
            ));
          }
        } else {
          return const Center();
        }
      },
    );
  }
}
