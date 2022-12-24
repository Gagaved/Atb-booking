import 'package:atb_booking/data/models/city.dart';
import 'package:atb_booking/data/models/level_plan.dart';
import 'package:atb_booking/data/models/office.dart';
import 'package:atb_booking/data/services/city_repository.dart';
import 'package:atb_booking/data/services/office_provider.dart';
import 'package:atb_booking/logic/user_role/feedback_bloc/feedback_bloc.dart';
import 'package:atb_booking/presentation/interface/user_role/booking/plan/plan_widget_for_feedback.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FeedBackScreen extends StatelessWidget {
  static final TextEditingController typeInputController =
      TextEditingController();
  static final TextEditingController cityInputController =
      TextEditingController();
  static final TextEditingController officeInputController =
      TextEditingController();
  static final TextEditingController levelInputController =
      TextEditingController();
  static final TextEditingController messageInputController =
      TextEditingController();
  const FeedBackScreen({super.key});

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
            padding: const EdgeInsets.only(top: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Инпут тип сообщения
                  _TypeField(),

                  /// Инпут города
                  _CityField(),

                  /// Инпут Офис и Этаж
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// Инпут Офиса
                        Expanded(flex: 13, child: _OfficeField()),
                        const SizedBox(width: 10),

                        ///Инпут Этажа
                        Expanded(flex: 10, child: _LevelField()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// Карта
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: BlocConsumer<FeedbackBloc, FeedbackState>(
                        listener: (context, state) {},
                        buildWhen: (previous, current) =>
                            (current is FeedbackMainState),
                        builder: (context, state) {
                          if (state is FeedbackMainState) {
                            if (state.workplaceFieldVisible) {
                              return const FeedbackLevelPlan();
                            } else {
                              return const Center();
                            }
                          } else {
                            throw Exception("Bad state: $state");
                          }
                        }),
                  ),

                  /// Поля для сообщения
                  const _MessageField(),
                  const SizedBox(height: 45),

                  /// Кнопка отправить
                  _Button(),
                  const SizedBox(height: 10)
                ]),
          ),
        ),
      ),
    );
  }
}

class _TypeField extends StatelessWidget {
  _TypeField();
  Future<List<String>> getFutureTypeList(String? str) async {
    List<String> type = ["Отзыв", "Жалоба"];
    return type;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: BlocBuilder<FeedbackBloc, FeedbackState>(
          buildWhen: (previous, current) => (current is FeedbackMainState),
          builder: (context, state) {
            if (state is FeedbackMainState) {
              if (state.isInitialState) {
                FeedBackScreen.typeInputController.clear();
                FeedBackScreen.cityInputController.clear();
                FeedBackScreen.officeInputController.clear();
                FeedBackScreen.levelInputController.clear();
                FeedBackScreen.messageInputController.clear();
              }
              if (state.typeFieldVisible) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith( fontSize: 20),
                      // decoration: const InputDecoration(
                      //   border: OutlineInputBorder(),
                      //   labelText: "Выберите тип обращения...",
                      // ),
                      decoration:InputDecoration(
                        hintText: "Выберите тип обращения...",
                        filled: true,
                        fillColor: Theme.of(context).backgroundColor,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        suffixIcon: Icon(Icons.arrow_drop_down,color: Theme.of(context).primaryColor),
                      ),
                      controller: FeedBackScreen.typeInputController,
                    ),
                    // После каждого ввода буквы в textField
                    suggestionsCallback: (pattern) {
                      return getFutureTypeList('');
                    },
                    itemBuilder: (context, String suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    onSuggestionSelected: (String suggestion) {
                      FeedBackScreen.cityInputController.clear();
                      FeedBackScreen.officeInputController.clear();
                      FeedBackScreen.levelInputController.clear();

                      FeedBackScreen.typeInputController.text = suggestion;
                      context
                          .read<FeedbackBloc>()
                          .add(FeedbackTypeFormEvent(suggestion));
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Please select a type' : null,
                  ),
                );
              } else {
                return Container();
              }
            } else {
              throw Exception("Bad state: $state");
            }
          }),
    );
  }
}

class _CityField extends StatelessWidget {
  _CityField();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
      child: BlocConsumer<FeedbackBloc, FeedbackState>(
          listener: (context, state) {},
          buildWhen: (previous, current) => (current is FeedbackMainState),
          builder: (context, state) {
            if (state is FeedbackMainState) {
              if (state.cityFieldVisible) {
                return TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Выберите город",
                      filled: true,
                      fillColor: Theme.of(context).backgroundColor,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    controller: FeedBackScreen.cityInputController,
                  ),
                  suggestionsCallback: (pattern) {
                    return CityRepository().getAllCities();
                  },
                  itemBuilder: (context, City suggestion) {
                    return ListTile(
                      title: Text(suggestion.name),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (City suggestion) {
                    FeedBackScreen.officeInputController.clear();
                    FeedBackScreen.levelInputController.clear();

                    FeedBackScreen.cityInputController.text = suggestion.name;
                    context
                        .read<FeedbackBloc>()
                        .add(FeedbackCityFormEvent(suggestion));
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Please select a city' : null,
                );
              } else {
                FeedBackScreen.cityInputController.clear();
                return const Center();
              }
            } else {
              throw Exception("Bad state: $state");
            }
          }),
    );
  }
}

class _OfficeField extends StatelessWidget {
  _OfficeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedbackBloc, FeedbackState>(
      listener: (context, state) {},
      buildWhen: (previous, current) => (current is FeedbackMainState),
      builder: (context, state) {
        if (state is FeedbackMainState) {
          if (state.officeFieldVisible) {
            return TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith( fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Выберите офис",
                  filled: true,
                  fillColor: Theme.of(context).backgroundColor,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                controller: FeedBackScreen.officeInputController,
              ),
              suggestionsCallback: (pattern) {
                return OfficeProvider()
                    .getOfficesByCityId(state.selectedCityId!.id);
              },
              itemBuilder: (context, Office suggestion) {
                return ListTile(
                  title: Text(suggestion.address),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (Office suggestion) {
                FeedBackScreen.levelInputController.clear();

                FeedBackScreen.officeInputController.text = suggestion.address;
                context
                    .read<FeedbackBloc>()
                    .add(FeedbackOfficeFormEvent(suggestion));
              },
              validator: (value) =>
                  value!.isEmpty ? 'Please select a office' : null,
            );
          } else {
            FeedBackScreen.officeInputController.clear();
            FeedBackScreen.levelInputController.clear();
            return const Center();
          }
        } else {
          throw Exception("Bad state: $state");
        }
      },
    );
  }
}

class _LevelField extends StatelessWidget {
  _LevelField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedbackBloc, FeedbackState>(
      listener: (context, state) {},
      buildWhen: (previous, current) => (current is FeedbackMainState),
      builder: (context, state) {
        if (state is FeedbackMainState) {
          if (state.levelFieldVisible) {
            return TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith( fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Этаж",
                  filled: true,
                  fillColor: Theme.of(context).backgroundColor,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                ),
                controller: FeedBackScreen.levelInputController,
              ),
              suggestionsCallback: (pattern) {
                return OfficeProvider()
                    .getLevelsByOfficeId(state.selectedOffice!.id);
              },
              itemBuilder: (context, LevelListItem suggestion) {
                return ListTile(
                  title: Text(suggestion.number.toString()),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (LevelListItem suggestion) {
                FeedBackScreen.levelInputController.text =
                    suggestion.number.toString();
                context
                    .read<FeedbackBloc>()
                    .add(FeedbackLevelFormEvent(suggestion));
              },
              validator: (value) =>
                  value!.isEmpty ? 'Please select a level' : null,
            );
          } else {
            FeedBackScreen.levelInputController.clear();
            return const Center();
          }
        } else {
          throw Exception("Bad state: $state");
        }
      },
    );
  }
}

class _MessageField extends StatelessWidget {
  const _MessageField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      buildWhen: (previous, current) => (current is FeedbackMainState),
      builder: (context, state) {
        if (state is FeedbackMainState) {
          if (state.messageFieldVisible) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text("Сообщение",
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w300)),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8),
                      child: TextField(
                        onChanged: (form) {
                          context
                              .read<FeedbackBloc>()
                              .add(FeedbackMessageInputEvent(form));
                        },
                        controller: FeedBackScreen.messageInputController,
                        decoration: InputDecoration(
                          hintText: "Введите текст сообщения...",
                          filled: true,
                          fillColor: Theme.of(context).backgroundColor,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        keyboardType: TextInputType.streetAddress,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith( fontSize: 20),
                        maxLines: 20,
                        minLines: 1,
                        maxLength: 1000,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        } else {
          throw Exception("Bad state: $state");
        }
      },
    );
  }
}

class _Button extends StatelessWidget {
  void _submitButton(BuildContext popupContext) async {
    bool _exit = false;

    await showDialog(
        context: popupContext,
        builder: (_) {
          return BlocProvider<FeedbackBloc>.value(
            value: popupContext.read<FeedbackBloc>(),
            child: BlocBuilder<FeedbackBloc, FeedbackState>(
              // buildWhen: (previous, current) => current is FeedbackPopupState,
              builder: (popupContext, state) {
                if (state is FeedbackPopupLoadingState) {
                  return const AlertDialog(
                    title: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is FeedbackSuccessState) {
                  _exit = true;
                  return const AlertDialog(
                    title: Text(
                      "Сообщение отправлено",
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (state is FeedbackPopupErrorState) {
                  return AlertDialog(
                    title: Text(
                      "Не удалось отправить сообщение",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(popupContext).colorScheme.error),
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
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      buildWhen: (previous, current) => (current is FeedbackMainState),
      builder: (context, state) {
        if (state is FeedbackMainState) {
          if (state.buttonVisible) {
            return Center(
              child: AtbElevatedButton(
                  onPressed: () {
                    context
                        .read<FeedbackBloc>()
                        .add(FeedbackButtonSubmitEvent());
                    _submitButton(context);
                  },
                  text: "Отправить"),
            );
          } else {
            return Container();
          }
        } else {
          throw Exception("Bad state: $state");
        }
      },
    );
  }
}
