import 'package:atb_booking/data/models/city.dart';
import 'package:atb_booking/data/models/office.dart';
import 'package:atb_booking/data/services/city_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/admin_role/offices/new_office_page/new_office_page_bloc.dart';
import 'package:atb_booking/logic/admin_role/offices/offices_screen/admin_offices_bloc.dart';
import 'package:atb_booking/logic/admin_role/offices/office_page/admin_office_page_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/booking_list_bloc/booking_list_bloc.dart';
import 'package:atb_booking/logic/user_role/profile_bloc/profile_bloc.dart';
import 'package:atb_booking/presentation/interface/admin_role/offices/new_office_page.dart';
import 'package:atb_booking/presentation/interface/admin_role/offices/office_page.dart';
import 'package:atb_booking/presentation/interface/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class AdminOfficesScreen extends StatelessWidget {
  const AdminOfficesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Офисы"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                BookingListBloc().add(BookingListInitialEvent());
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const Auth()));
                NetworkController()
                    .exitFromApp(); //todo вынести в блок как эвент и ждать
              },
              icon: const Icon(Icons.logout, size: 28))
        ],
      ),
      body: Column(
        children: [
          const _CityField(),
          _OfficesList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return MultiBlocProvider(providers: [
              BlocProvider.value(
                value: context.read<
                    AdminOfficesBloc>(), //context.read<NewOfficePageBloc>(),
              ),
              BlocProvider<NewOfficePageBloc>(
                  create: (context) =>
                      NewOfficePageBloc() //context.read<NewOfficePageBloc>(),
                  ),
              BlocProvider(
                  create: (context) =>
                      AdminOfficePageBloc() //context.read<AdminOfficePageBloc>(),
                  ),
            ], child: const NewOfficePage());
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
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "Выберите город...",
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
              return CityProvider()
                  .getCitiesByName(pattern); // state.futureCityList;
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
            errorBuilder: (context,er){
              return Flexible(child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Не удалось загрузить, проверьте интернет соеденение.",style: Theme.of(context).textTheme.bodyMedium,),
              ),);},
            noItemsFoundBuilder: (context){
              return Flexible(child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Не удалось найти город с таким именем",style: Theme.of(context).textTheme.bodyMedium,),
              ),);
            },
            onSuggestionSelected: (City suggestion) {
              _cityInputController.text = suggestion.name;
              context
                  .read<AdminOfficesBloc>()
                  .add(AdminOfficesCitySelectedEvent(suggestion));
              //todo _selectedCity = suggestion;
            },
            validator: (value) =>
                value!.isEmpty ? 'Введите название города' : null,
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
          if (state.offices.isNotEmpty) {
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
          } else {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "В этом городе пока нет офисов",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }
        } else if (state is AdminOfficesLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AdminOfficesInitial) {
          return Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Чтобы добавить офис используйте кнопку ниже",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, animation, secondaryAnimation) =>
                  MultiBlocProvider(providers: [
                BlocProvider.value(
                  value: context.read<AdminOfficesBloc>(),
                ),
                BlocProvider<AdminOfficePageBloc>(
                    create: (_) => AdminOfficePageBloc()
                      ..add(OfficePageLoadEvent(officeListItem.id)))
              ], child: const OfficePage()),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AddressRow(officeListItem: officeListItem),
                _WorkTimeRangeRow(officeListItem: officeListItem)
              ],
            ),
          )),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final Office officeListItem;

  const _AddressRow({required this.officeListItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        // decoration: BoxDecoration(
        //   color: AtbAdditionalColors.black7,
        //   borderRadius: BorderRadius.circular(20),
        // ),
        child: Text(
          officeListItem.address,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class _WorkTimeRangeRow extends StatelessWidget {
  final Office officeListItem;

  const _WorkTimeRangeRow({required this.officeListItem});

  @override
  Widget build(BuildContext context) {
    String text =
        "c ${DateFormat('HH:mm').format(officeListItem.workTimeRange.start)} до ${DateFormat('HH:mm').format(officeListItem.workTimeRange.end)}";
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        child: Text(
          "Работает " + text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
