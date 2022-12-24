import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/adding_people_to_booking_bloc/adding_people_to_booking_bloc.dart';
import 'package:atb_booking/logic/user_role/feedback_bloc/feedback_bloc.dart';
import 'package:atb_booking/presentation/constants/styles.dart';
import 'package:atb_booking/presentation/interface/user_role/feedback/feedback_screen.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class AddingPeopleWidget extends StatelessWidget {
  const AddingPeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      insetPadding: const EdgeInsets.all(10),
      contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      content: SizedBox(
        width: 1000,
        height: 750,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: SearchBar(),
            ),
            Expanded(
              child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Stack(children: [
                      SearchResultPeopleList(),
                      const HorizontalPeopleAddedList(),
                    ]),
                    BlocConsumer<AddingPeopleToBookingBloc,
                        AddingPeopleToBookingState>(
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AtbElevatedButton(
                            onPressed: () {
                              context
                                  .read<AddingPeopleToBookingBloc>()
                                  .add(AddingPeopleToBookingButtonPressEvent());
                              Navigator.pop(context);
                            },
                            text: state.selectedUsers.length == 0
                                ? "Назад"
                                : "Добавить",
                            icon: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: state.selectedUsers.length != 0
                                  ? Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Center(
                                          child: Text(
                                        '+${state.selectedUsers.length}',
                                        style: Theme.of(context)
                                            .textTheme.titleMedium!
                                            .copyWith(
                                                color:
                                                Theme.of(context).primaryColor),
                                      )),
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  SearchBar({Key? key}) : super(key: key);
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    _onSearchChanged(String query) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        context
            .read<AddingPeopleToBookingBloc>()
            .add(AddingPeopleLoadEvent(query, true));
      });
    }

    return TextField(
      decoration: InputDecoration(
        hintText: "Введите имя...",
        filled: true,
        fillColor: Theme.of(context).backgroundColor,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        suffixIcon:
            BlocConsumer<AddingPeopleToBookingBloc, AddingPeopleToBookingState>(
          buildWhen: (context, state) {
            return (state is AddingPeopleToBookingInitial ||
                state is AddingPeopleToBookingLoadedState);
          },
          builder: (context, state) {
            return SizedBox(
              width: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "только\nизбранные",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  IconButton(
                    isSelected: state.isFavoriteOn,
                    onPressed: () {
                      context.read<AddingPeopleToBookingBloc>().add(
                          AddingPeopleToBookingIsFavoriteChangeEvent(
                              !(state.isFavoriteOn), _controller.text));
                    },
                    icon: state.isFavoriteOn
                        ? Icon(Icons.star, color: Theme.of(context).primaryColor)
                        : Icon(
                            Icons.star_border,
                            color: Theme.of(context).primaryColor,
                          ),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            //print("listener");
          },
        ),
      ),
      textInputAction: TextInputAction.search,
      controller: _controller,
      onChanged: (pattern) {
        // при добавлении или стирании в поле
        _onSearchChanged(pattern);
      },
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
    );
  }
}

class SearchResultPeopleList extends StatelessWidget {
  SearchResultPeopleList({Key? key}) : super(key: key);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        print("scroll end listener");
        context
            .read<AddingPeopleToBookingBloc>()
            .add(AddingPeopleToBookingLoadNextPageEvent());
      }
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Center(
        child:
            BlocConsumer<AddingPeopleToBookingBloc, AddingPeopleToBookingState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          buildWhen: (context, state) {
            print(state.toString());
            return (state is AddingPeopleToBookingLoadedState ||
                state is AddingPeopleToBookingLoadingState);
          },
          builder: (context, state) {
            if ((state is AddingPeopleToBookingLoadedState)) {
              return SizedBox(
                height: double.infinity,
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap:
                        true, // оптимизирует скрол, не хроня лишние знач
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      var user = state.users[index];
                      bool isSelect = state.selectedUsers[user.id] != null;
                      double padTop = 0.0;
                      double padBot = 0.0;
                      if (index == 0) {
                        padTop = 50.0;
                      }
                      if (index == state.users.length - 1) {
                        padBot = 80.0;
                      }
                      return Padding(
                        padding: EdgeInsets.fromLTRB(0, padTop, 0, padBot),
                        child: Column(
                          children: [
                            AddingPeoplePersonCard(user: user,isSelect: isSelect)
                          ],
                        ),
                      );
                    }),
              );
            } else if (state is AddingPeopleToBookingLoadingState) {
              return SizedBox(
                height: double.infinity,
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      var user = state.users[index];
                      bool isSelect =
                          state.selectedUsers[user.id] != null;
                      double padtop = 0.0;
                      if (index == 0) {
                        padtop = 50.0;
                      }
                      return Padding(
                        padding: EdgeInsets.fromLTRB(0, padtop, 0, 0),
                        child: Column(
                          children: [
                            AddingPeoplePersonCard(user: user,isSelect: isSelect),
                            index == state.users.length - 1
                                ? Container(
                                    height: 150,
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ))
                                : const SizedBox.shrink(),
                          ],
                        ),
                      );
                    }),
              );
            } else {
              return const Center(
                child: Text(""),
              );
            }
          },
        ),
      ),
    );
  }
}

class HorizontalPeopleAddedList extends StatelessWidget {
  const HorizontalPeopleAddedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddingPeopleToBookingBloc, AddingPeopleToBookingState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        List<User> list =
            state.selectedUsers.entries.map((e) => e.value).toList();
        return SizedBox(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: false,
              itemCount: state.selectedUsers.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 50,
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    clipBehavior: Clip.antiAlias,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Text(list[index].fullName,
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(color: Colors.white)),
                          ),
                          IconButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              context.read<AddingPeopleToBookingBloc>().add(
                                  AddingPeopleToBookingDeselectUserEvent(
                                      list[index]));
                            },
                            icon: const Icon(
                              Icons.highlight_remove_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}


class AddingPeoplePersonCard extends StatelessWidget {
  final bool isSelect;
  final User user;

  const AddingPeoplePersonCard({super.key, required this.isSelect, required this.user});
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      // чтоб обрезал края при нажатии на карт
      child: InkWell(
        onTap: () {
          if (!isSelect) {
            context
                .read<AddingPeopleToBookingBloc>()
                .add(
                AddingPeopleToBookingSelectUserEvent(
                    user));
          } else {
            context.read<AddingPeopleToBookingBloc>().add(
                AddingPeopleToBookingDeselectUserEvent(
                    user));
          }
        },
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                leading: Stack(
                  children: [Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: AppImageProvider
                                      .getImageUrlFromImageId(user.avatarImageId,),
                                  httpHeaders: NetworkController()
                                      .getAuthHeader(),
                                  progressIndicatorBuilder: (context,
                                      url, downloadProgress) =>
                                      Center(
                                          child:
                                          CircularProgressIndicator(
                                              value:
                                              downloadProgress
                                                  .progress)),
                                  errorWidget: (context, url, error) =>
                                      Container()),
                            ),
                          ),
                          isSelect
                              ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AtbAdditionalColors
                                  .primalTranslucent,
                            ),
                            child: isSelect
                              ? const Icon(
                              Icons.check,
                              size: 50.0,
                              color: Colors.white,
                            )
                              : Icon(
                              Icons
                                .check_box_outline_blank,
                              size: 30.0,
                              color: Theme.of(context)
                                .primaryColor,
                            ),
                          )
                              : const SizedBox.shrink(),
                        ]),
                  ),
                    user.isFavorite
                        ? Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child:
                        Icon(Icons.star, color: Theme.of(context).primaryColor))
                        : const SizedBox.shrink()
                  ]
                ),
                trailing: IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _showSimpleDialog(context,user);
                    },
                    icon: const Icon(Icons.more_vert)),
                title:
                Text(user.fullName),
                subtitle:
                Text(user.email,style: Theme.of(context).textTheme.bodySmall,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showSimpleDialog(BuildContext contextDialog, User user) {
  showDialog(
      context: contextDialog,
      builder: (context) {
        return BlocProvider.value(
          value: BlocProvider.of<AddingPeopleToBookingBloc>(contextDialog),
          child: SimpleDialog(
            title: Text(
              user.fullName,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  await _feedbackTransition(context);
                },
                child: Row(
                  children: [
                    const Icon(Icons.report_gmailerrorred),
                    const SizedBox(width: 10),
                    Text('Пожаловаться',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // TODO сделать пользователя избранным
                  if (!user.isFavorite) {
                    contextDialog
                        .read<AddingPeopleToBookingBloc>()
                        .add(AddingPeopleToBookingToFavoriteEvent(user));
                    Navigator.pop(context);
                  } else {
                    // TODO удалить из избранных
                    contextDialog
                        .read<AddingPeopleToBookingBloc>()
                        .add(AddingPeopleToBookingRemoveFromFavoriteEvent(user));
                    Navigator.pop(context);
                  }
                },
                child: Row(
                  children: [
                    if (user.isFavorite) ...[
                      const Icon(Icons.star),
                      const SizedBox(width: 10),
                      Text('Убрать из избранного',
                          style: Theme.of(context).textTheme.titleMedium),
                    ] else ...[
                      const Icon(
                        Icons.star_border,
                      ),
                      const SizedBox(width: 10),
                      Text('Добавить в избранные',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

 _feedbackTransition(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => BlocProvider(
  create: (context) => FeedbackBloc(),
  child: const FeedBackScreen(),
)),
  );
}
