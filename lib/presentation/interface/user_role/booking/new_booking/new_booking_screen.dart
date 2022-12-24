import 'package:atb_booking/data/models/city.dart';
import 'package:atb_booking/data/models/level_plan.dart';
import 'package:atb_booking/data/models/office.dart';
import 'package:atb_booking/data/services/city_provider.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_sheet_bloc/new_booking_sheet_bloc.dart';
import 'package:atb_booking/presentation/interface/user_role/booking/plan/planWidget.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'new_booking_bottom_sheet.dart';

class NewBookingScreen extends StatelessWidget {
  const NewBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Бронирование"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///
              ///
              /// Поле инпута города
              _CityField(),

              ///
              ///
              /// Инпут офиса и этажа
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///
                    ///
                    /// Инпут офиса
                    Expanded(flex: 13, child: _OfficeField()),
                    const SizedBox(width: 10),

                    ///
                    ///
                    ///Инпут этажа
                    const Expanded(flex: 10, child: _LevelField()),
                  ],
                ),
              ),

              ///
              ///
              /// Карта
              BlocConsumer<NewBookingBloc, NewBookingState>(
                  listener: (context, state) {
                // TODO: implement listener
              }, builder: (context, state) {
                if (state is NewBookingFourthState) {
                  return const PlanWidget();
                } else {
                  return const Center();
                }
              }),

              ///
              ///
              /// Кнопка "Выбрать время"
              const _ButtonShowBottomSheet(),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }
}

class _CityField extends StatelessWidget {
  ///
  ///City input fields
  /// -> -> ->
  final TextEditingController _cityInputController = TextEditingController();

  _CityField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewBookingBloc, NewBookingState>(
        listener: (context, state) {},
        buildWhen: (previous, current) {
          return current is NewBookingFirstState; //todo add another states
        },
        builder: (context, state) {
          if (state is NewBookingFirstState) {
            _cityInputController.text = state.labelCity;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: TypeAheadFormField(
              noItemsFoundBuilder: (context){
                return Flexible(child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Не удалось найти город с таким именем",style: Theme.of(context).textTheme.bodyMedium,),
                ),);
              },
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  hintText: "Выберите город",
                  filled: true,
                  fillColor: Theme.of(context).backgroundColor,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  suffixIcon: const Icon(Icons.search),
                ),
                controller: _cityInputController,
              ),
              suggestionsCallback: (pattern) {
                // при нажатии на поле
                return CityProvider().getCitiesByName(pattern); //CityRepository().getAllCities();
              },
              itemBuilder: (context, City suggestion) {
                return ListTile(
                  title: Text(suggestion.name),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                // при вводи чего то в форму
                return suggestionsBox;
              },
              onSuggestionSelected: (City suggestion) {
                _cityInputController.text = suggestion.name;
                context
                    .read<NewBookingBloc>()
                    .add(NewBookingCityFormEvent(suggestion));
                //todo _selectedCity = suggestion;
              },
              validator: (value) =>
                  value!.isEmpty ? 'Введите город' : null,
              //onSaved: (value) => this._selectedCity = value,
            ),
          );
        });
  }
}

class _OfficeField extends StatelessWidget {
  final TextEditingController _officeInputController = TextEditingController();

  _OfficeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewBookingBloc, NewBookingState>(
        listener: (context, state) {},
        buildWhen: (previous, current) {
          return current is NewBookingSecondState ||
              false; //todo add another states
        },
        builder: (context, state) {
          if (state is NewBookingSecondState) {
            _officeInputController.text = state.labelOffice;
            return TypeAheadFormField(
              noItemsFoundBuilder: (context){
                return Flexible(child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Не удалось найти офис с таким адерсом",style: Theme.of(context).textTheme.bodyMedium,),
                ),);
              },
              errorBuilder: (context,er){
                return Flexible(child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Не удалось загрузить, проверьте интернет соеденение.",style: Theme.of(context).textTheme.bodyMedium,),
                ),);

              },
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  hintText: "Выберите офис",
                  filled: true,
                  fillColor: Theme.of(context).backgroundColor,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                controller: _officeInputController,
              ),
              suggestionsCallback: (pattern) {
                return (state).futureOfficeList;
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
                _officeInputController.text = suggestion.address;
                context
                    .read<NewBookingBloc>()
                    .add(NewBookingOfficeFormEvent(suggestion));
                //todo _selectedCity = suggestion;
              },
              validator: (value) =>
                  value!.isEmpty ? 'Please select a office' : null,
              //onSaved: (value) => this._selectedCity = value,
            );
          }
          return const Center();
        });
  }
}

class _LevelField extends StatelessWidget {
  const _LevelField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewBookingBloc, NewBookingState>(
        listener: (context, state) {},
        // buildWhen: (previous, current) {
        //    return current is NewBookingThirdState ||
        //        false; //todo add another states
        // },
        builder: (context, state) {
          if (state is NewBookingThirdState) {
            return Container(
              decoration: BoxDecoration(
                //color: appThemeData.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(10).copyWith(),
              ),
              child: DropdownSearch<LevelListItem>(
                selectedItem: state.selectedLevel,
                onChanged: (level) {
                  if (level != null) {
                    context
                        .read<NewBookingBloc>()
                        .add(NewBookingLevelFormEvent(level));
                  }
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Введите имя...",
                    filled: true,
                    fillColor: Theme.of(context).backgroundColor,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                asyncItems: (state).getFutureLevelList,
                //asyncItems: getFutureLevelList,
                itemAsString: (LevelListItem level) {
                  return "${level.number} Этаж";
                },
                dropdownBuilder: (BuildContext context, LevelListItem? level) {
                  if (level != null) {
                    return Text(
                      "${level.number} Этаж",
                      style: Theme.of(context).textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                popupProps: const PopupProps.menu(
                  //showSearchBox: true,
                  fit: FlexFit.loose,
                  constraints: BoxConstraints.tightFor(),
                ),
              ),
            );
          } else {
            return const Center();
          }
        });
  }
}

class _ButtonShowBottomSheet extends StatelessWidget {
  const _ButtonShowBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewBookingBloc, NewBookingState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is NewBookingFifthState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: AtbElevatedButton(
                onPressed: () {
                  NewBookingBloc().add(NewBookingButtonTimeEvent());
                  showModalBottomSheet<void>(
                    builder: (BuildContext context) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                          value: NewBookingSheetBloc(),
                        ),
                        ],
                        child: const BookingBottomSheet(),
                      );
                    },
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    )),
                    context: context,
                  );
                },
                text: "Выбрать время"),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
