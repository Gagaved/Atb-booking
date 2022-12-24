import 'dart:async';
import 'package:atb_booking/logic/user_role/people_bloc/people_bloc.dart';
import 'package:atb_booking/presentation/interface/user_role/people/person_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PeopleBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Люди"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SearchPeopleTextField(),
              SearchResultList(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPeopleTextField extends StatelessWidget {
  final _controller = TextEditingController();
  static Timer? _debounce;

  SearchPeopleTextField({super.key});

  @override
  Widget build(BuildContext context) {
    _onSearchChanged(String query) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        context.read<PeopleBloc>().add(PeopleLoadEvent(query, true));
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 20,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Введите имя",
                filled: true,
                fillColor: Theme.of(context).backgroundColor,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                suffixIcon: BlocBuilder<PeopleBloc, PeopleState>(
                  builder: (context, state) {
                    return IconButton(
                        onPressed: () {
                          context
                              .read<PeopleBloc>()
                              .add(
                              PeopleIsFavoriteChangeEvent(_controller.text));
                        },
                        icon: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text("Только\nизбранные",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleSmall,
                                textAlign: TextAlign.right),
                            const SizedBox(width: 10),
                            state.isFavoriteOn
                                ? const Icon(Icons.star,)
                                : const Icon(
                              Icons.star_border,
                            ),
                          ],
                        ));
                  },
                ),
              ),
              textInputAction: TextInputAction.search,
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

class SearchResultList extends StatelessWidget {
  SearchResultList({super.key});

  static ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        context.read<PeopleBloc>().add(PeopleLoadNextPageEvent());
      }
    });
    return BlocBuilder<PeopleBloc, PeopleState>(
      builder: (context, state) {
        if (state is PeopleLoadedState) {
          if (state.formHasBeenChanged) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(0);
            }
          }
        }
        if (state is PeopleInitialState) {
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
        if (state is PeopleLoadedState) {
          if(state.users.isEmpty){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Ничего не найдено"
                    ,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ));
          }
          return Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: false,
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    PersonCard(state.users[index]),
                    (state is PeopleLoadingState &&
                        index == state.users.length - 1)
                        ? Container(
                        height: 150,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ))
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          );
        }
        else if (state is PeopleLoadingState) {
          if (state.page == 0) {
            return Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: false,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return
                   const ShimmerPersonCard();
                },
              ),
            );
          }
          return Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: false,
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    PersonCard(state.users[index]),
                    (state is PeopleLoadingState &&
                        index == state.users.length - 1)
                        ? Container(
                        height: 150,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ))
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          );
        } else {
          return ErrorWidget((Exception("bad state: $state")));
        }
      },
    );
  }
}
