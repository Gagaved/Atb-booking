import 'package:atb_booking/logic/admin_role/feedback/admin_feedback_bloc.dart';
import 'package:atb_booking/logic/admin_role/offices/offices_screen/admin_offices_bloc.dart';
import 'package:atb_booking/logic/admin_role/people/people_page/admin_people_bloc.dart';
import 'package:atb_booking/presentation/interface/admin_role/feedback/feedback_screen.dart';
import 'package:atb_booking/presentation/interface/admin_role/offices/offices_list_screen.dart';
import 'package:atb_booking/presentation/interface/admin_role/people/people_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _HomeState();
}

class _HomeState extends State<AdminHome> {
  int selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const AdminOfficesScreen(),
    const AdminPeopleScreen(),
     const AdminFeedbackScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  build(BuildContext context) {
    return

        MultiBlocProvider(
          providers: [
            BlocProvider<AdminOfficesBloc>(
              create: (context) => AdminOfficesBloc(),
            ),
            BlocProvider<AdminPeopleBloc>(
              create: (context) => AdminPeopleBloc(),
            ),
            BlocProvider<AdminFeedbackBloc>(
              create: (context) => AdminFeedbackBloc(),
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
                          icon: Icon(Icons.apartment_rounded),
                           label: 'Офисы',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.people_outline_rounded),
                          label: 'Люди',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.feed),
                          label: 'Фидбек',
                        ),
                      ],
                    ),
                  ))),
        );
  }
}
