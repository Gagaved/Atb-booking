import 'package:atb_booking/logic/user_role/booking/booking_list_bloc/booking_list_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/locked_plan_bloc/locked_plan_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_sheet_bloc/new_booking_confirmation_popup_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_sheet_bloc/new_booking_sheet_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/plan_bloc/plan_bloc.dart';
import 'package:atb_booking/logic/user_role/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../booking/booking_list/booking_list_screen.dart';
import '../people/people_screen.dart';
import '../profile/profile_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const BookingScreen(),
    const PeopleScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BookingListBloc()..add(BookingListLoadEvent()),
        ),
        BlocProvider.value(
          value:  NewBookingConfirmationPopupBloc(),
        ),
        BlocProvider.value(
          value: PlanBloc(),
        ),
        BlocProvider.value(
            value: LockedPlanBloc()),
        BlocProvider.value(
          value: NewBookingBloc()..add(NewBookingInitialEvent()),
        ),
        BlocProvider.value(
          value:  NewBookingSheetBloc(),
        ),
        BlocProvider.value(
          value:  ProfileBloc(),
        ),
      ],
      child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 00),
                child: Center(
                  child: _widgetOptions.elementAt(selectedIndex),
                ),
              ),
              bottomNavigationBar: NavigationBarTheme(
                  data: NavigationBarThemeData(
                    iconTheme: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return const IconThemeData(
                          color: Colors.white,
                        );
                      } else {
                        return IconThemeData(color: Theme.of(context).primaryColor);
                      }
                    }),
                    indicatorColor: Theme.of(context).primaryColor,
                    //surfaceTintColor: Colors.lightGreen,
                  ),
                  child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                    child: NavigationBar(
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (index) => setState(() {
                        selectedIndex = index;
                      }),
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.cases_outlined),
                          label: 'Бронирование',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.people_outline_rounded),
                          label: 'Люди',
                        ),
                        NavigationDestination(
                            icon: Icon(Icons.person), label: 'Профиль')
                      ],
                    ),
                  ))),
    );
  }
}
