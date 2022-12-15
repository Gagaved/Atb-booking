import 'package:atb_booking/data/models/city.dart';
import 'package:atb_booking/data/models/office.dart';
import 'package:atb_booking/data/services/city_provider.dart';
import 'package:atb_booking/logic/admin_role/offices/new_office_page/new_office_page_bloc.dart';
import 'package:atb_booking/logic/admin_role/offices/offices_screen/admin_offices_bloc.dart';
import 'package:atb_booking/logic/admin_role/offices/office_page/admin_office_page_bloc.dart';
import 'package:atb_booking/presentation/interface/admin_role/offices/new_office_page.dart';
import 'package:atb_booking/presentation/interface/admin_role/offices/office_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AdminOfficesScreen extends StatelessWidget {
  const AdminOfficesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Офисы")),
      body: Column(
        children: [
          _CityField(),
          _OfficesList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return BlocProvider<NewOfficePageBloc>(
              create: (context) => NewOfficePageBloc(),
              child: const NewOfficePage(),
            );
          }));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _CityField extends StatelessWidget {
  ///
  ///City input fields
  /// -> -> ->
  static final TextEditingController _cityInputController =
  TextEditingController();

  const _CityField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOfficesBloc, AdminOfficesState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Выберите город...",
              ),
              controller: _cityInputController,
            ),
            suggestionsCallback: (pattern) {
              // при нажатии на поле
              return CityProvider().getCitiesByName(pattern);// state.futureCityList;
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
                  .read<AdminOfficesBloc>()
                  .add(AdminOfficesCitySelectedEvent(suggestion));
              //todo _selectedCity = suggestion;
            },
            validator: (value) =>
            value!.isEmpty ? 'Please select a city' : null,
            //onSaved: (value) => this._selectedCity = value,
          ),
        );
      },
    );
  }
}

class _OfficesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOfficesBloc, AdminOfficesState>(
      builder: (context, state) {
        if (state is AdminOfficesLoadedState) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: state.offices.length,
                itemBuilder: (context, index) {
                  return OfficeCard(
                    officeListItem: (state).offices[index],
                  );
                },
              ),
            ),
          );
        } else if (state is AdminOfficesLoadingState) {
          return const Center(
            child: Text("loading state"),
          );
        } else if (state is AdminOfficesInitial) {
          return const Center(
            child: Text("initial state"),
          );
        } else {
          throw Exception("Unknown AdminOfficesBloc state: $state");
        }
      },
    );
  }
}

class OfficeCard extends StatelessWidget {
  final Office officeListItem;

  const OfficeCard({super.key, required this.officeListItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AdminOfficePageBloc>().add(OfficePageLoadEvent(officeListItem.id));
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (cont) =>
                  BlocProvider.value(
                    value: context.read<AdminOfficePageBloc>(),
                    child: OfficePage(),
                  )),
        );
      },
      child: Card(
          child: ListTile(
            title: Text(officeListItem.address),
            subtitle: Text("ID: ${officeListItem.id}"),
          )),
    );
  }
}