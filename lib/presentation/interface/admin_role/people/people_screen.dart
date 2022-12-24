import 'dart:async';

import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/admin_role/people/people_page/admin_people_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/booking_list_bloc/booking_list_bloc.dart';
import 'package:atb_booking/presentation/interface/admin_role/people/admin_person_card.dart';
import 'package:atb_booking/presentation/interface/auth/auth_screen.dart';
import 'package:atb_booking/presentation/interface/user_role/people/person_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPeopleScreen extends StatelessWidget {
  const AdminPeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("      Люди"),
        ),
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
          _PeopleSearchField(),
          const _PeopleSearchResultList(),
        ],
      ),
    );
  }
}

class _PeopleSearchField extends StatelessWidget {
  static final _controller = TextEditingController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    _onSearchChanged(String query) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        context.read<AdminPeopleBloc>().add(AdminPeopleLoadEvent(query, true));
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "Введите имя...",
                filled: true,
                fillColor: Theme.of(context).backgroundColor,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                suffixIcon: const Icon(Icons.search),
              ),
              controller: _controller,
              onChanged: (pattern) {
                // при добавлении или стирании в поле
                _onSearchChanged(pattern);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PeopleSearchResultList extends StatelessWidget {
  const _PeopleSearchResultList();

  static final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        context.read<AdminPeopleBloc>().add(AdminPeopleLoadNextPageEvent());
      }
    });
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<AdminPeopleBloc, AdminPeopleState>(
            builder: (context, state) {
          if (state is AdminPeopleLoadedState) {
            if (state.formHasBeenChanged) {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(0);
              }
            }
          }
          if (state is AdminPeopleInitialState) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Введите имя человека в строку поиска выше",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }
          if (state.users.isNotEmpty) {
            if (state is AdminPeopleLoadingState && state.page ==0) {
              return ListView.builder(
                controller: _scrollController,
                shrinkWrap: false,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const ShimmerPersonCard();
                },);
            } else {
              return ListView.builder(
                  //controller: _scrollController,
                  shrinkWrap: false,
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        AdminPersonCard(state.users[index]),
                        (state is AdminPeopleLoadingState &&
                                index == state.users.length - 1)
                            ? Container(
                                height: 150,
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 100),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ))
                            : const SizedBox.shrink(),
                      ],
                    );
                  });
            }
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Ничего не найдено",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
