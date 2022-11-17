import 'package:atb_booking/data/dataclasses/office.dart';
import 'package:atb_booking/user_interface/widgets/elevated_button.dart';
import 'package:atb_booking/user_interface/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/styles.dart';
import '../../data/dataclasses/city.dart';
import '../../data/dataclasses/workspace.dart';
import 'new_booking_bottom_sheet.dart';

const List<String> list = <String>['1 Этаж', '2 Этаж', '3 Этаж', '4 Этаж'];
Workspace workspace = Workspace(
  id: 1,
  isActive: true,
  levelId: 1,
  name: "Переговорная комната #1",
  numberOfWorkspaces: 1,
  typeId: 1,
  positionOnPlan: {"x": 1, "y": 2},
);
Office office = Office(
    id: 1,
    address: "Ул пушкина дом колотушкина",
    cityId: 1,
    maxDuration: Duration(days: 30));
City city = City(id: 1, name: "Владивосток");

class NewBookingScreen extends StatefulWidget {
  const NewBookingScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewBookingScreenState();
  }
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Бронирование"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Expanded(
                        flex: 1,
                        child: AtbTextField(text: "Выберите город...",)
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: AtbTextField(text: "Выберите офис...",)
                      ),
                      const SizedBox(width: 10),
                      const Expanded(flex: 1, child: DropdownButtonLevel()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(children: const [
                    Flexible(child: Image(image: AssetImage("assets/map.png"))),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                      child: Text(
                        workspace.name,
                        textAlign: TextAlign.center,
                        style: appThemeData.textTheme.headlineSmall,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: appThemeData.colorScheme.tertiary,
                              borderRadius:
                                  BorderRadius.circular(10).copyWith(),
                            ),
                            child: const _DatePickerWidget()),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: AtbElevatedButton(
                        onPressed: () => {
                              showModalBottomSheet<void>(
                                builder: (BuildContext context) {
                                  return const BookingBottomSheet();
                                },
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                )),
                                context: context,
                              ),
                            },
                        text: "Выбрать время")
                    )
              ],
            ),
          ),
        ));
  }
}

class DropdownButtonLevel extends StatefulWidget {
  const DropdownButtonLevel({super.key});

  @override
  State<DropdownButtonLevel> createState() => _DropdownButtonLevelState();
}

class _DropdownButtonLevelState extends State<DropdownButtonLevel> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: appThemeData.primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 120,
        height: 60,
        child: Center(
          child: DropdownButton<String>(
            iconDisabledColor: Colors.white,
            iconEnabledColor: Colors.white,
            dropdownColor: appThemeData.primaryColor,
            icon: const Icon(Icons.arrow_downward),
            value: dropdownValue,
            elevation: 16,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(
                    child: Text(value,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white))),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _DatePickerWidget extends StatefulWidget {
  const _DatePickerWidget();

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<_DatePickerWidget> {
  static DateTime? _selectedDate;
  static String _defaultText = "Выберите дату";
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_selectedDate != null) {
      _defaultText = "Выберите дату";
      _textEditingController.text =
          (DateFormat('dd.MM.yyyy').format(_selectedDate!)).toString();
    }
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: _defaultText,
      ),
      focusNode: AlwaysDisabledFocusNode(),
      controller: _textEditingController,
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                  // header background color
                  onPrimary: Colors.white,
                  // header text color
                  onSurface: Theme.of(context).primaryColor, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red, // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
          context: context,
          initialDate: DateTime(1222),
          firstDate: DateTime(1200),
          lastDate: DateTime(2100),
        );
        if (newDate != null) {
          _textEditingController.text =
              (DateFormat('dd.MM.yyyy').format(newDate)).toString();
          setState(() {
            //_defaultText = "";
          });
        }
      },
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
