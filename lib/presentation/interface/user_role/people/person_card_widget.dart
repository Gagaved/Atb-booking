import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/user_role/feedback_bloc/complaint_bloc/complaint_bloc.dart';
import 'package:atb_booking/logic/user_role/people_bloc/people_bloc.dart';
import 'package:atb_booking/logic/user_role/people_profile_bloc/people_profile_booking_bloc.dart';
import 'package:atb_booking/presentation/constants/styles.dart';
import 'package:atb_booking/presentation/interface/user_role/feedback/user_complaint.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'person_profile_screen.dart';


class PersonCard extends StatelessWidget {
  final User user;

  const PersonCard(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: PeopleProfileBookingBloc()
                ..add(PeopleProfileBookingLoadEvent(id: user.id)),
              child: PersonProfileScreen(user),
            ),
          ),
        );
      },
      child: Card(
          semanticContainer: true,
          elevation: 1,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 0, color: appThemeData.colorScheme.tertiary),
              borderRadius: BorderRadius.circular(12.0)),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipOval(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: AppImageProvider.getImageUrlFromImageId(
                                user.avatarImageId,
                              ),
                              httpHeaders: NetworkController().getAuthHeader(),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                              errorWidget: (context, url, error) =>
                                  Container()),
                        ),
                      ),
                    ),
                    user.isFavorite
                        ? Icon(Icons.star, color: appThemeData.primaryColor)
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              Expanded(
                  child: ListTile(
                title: Text(user.fullName,
                    style: appThemeData.textTheme.titleMedium),
                subtitle: Text(
                  user.email,
                  style: appThemeData.textTheme.titleSmall,
                ),
                trailing: GestureDetector(
                    onTap: () {
                      _showSimpleDialog(context, user);
                    },
                    child: const Icon(Icons.more_vert, color: Colors.black)),
                dense: true,
                minLeadingWidth: 100,
              ))
            ],
          )),
    ));
  }
}


class ShimmerPersonCard extends StatelessWidget {
  const ShimmerPersonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Stack(children: [
        Shimmer.fromColors(
          highlightColor: const Color.fromARGB(66, 220, 220, 220),
          baseColor: const Color.fromARGB(211, 217, 217, 217),
          child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: SizedBox(
                height: 75,
                child: Row(children: [
                  Expanded(
                    flex: 65,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                            ],
                          ),
                          //_WorkspaceRow(booking),
                          //_AddressRow(booking),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 35, child: Container()),
                ]),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Shimmer.fromColors(
              highlightColor: const Color.fromARGB(111, 182, 182, 182),
              baseColor: const Color.fromARGB(163, 196, 196, 196),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Card(
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0)),
                    child: Center(
                      child: SizedBox(
                        height: 55,
                        width: 55,
                        child: Row(children: [
                          Expanded(
                            flex: 65,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      //_TimeRow(booking),
                                    ],
                                  ),
                                  //_WorkspaceRow(booking),
                                  //_AddressRow(booking),
                                ],
                              ),
                            ),
                          ),
                          Expanded(flex: 35, child: Container()),
                        ]),
                      ),
                    )),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    highlightColor: const Color.fromARGB(111, 182, 182, 182),
                    baseColor: const Color.fromARGB(163, 196, 196, 196),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 15),
                      child: Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: SizedBox(
                            height: 15,
                            width: 160,
                            child: Row(children: [
                              const Expanded(
                                flex: 65,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                ),
                              ),
                              Expanded(flex: 35, child: Container()),
                            ]),
                          )),
                    ),
                  ),Shimmer.fromColors(
                    highlightColor: const Color.fromARGB(111, 182, 182, 182),
                    baseColor: const Color.fromARGB(163, 196, 196, 196),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 15),
                      child: Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: SizedBox(
                            height: 15,
                            width: 100,
                            child: Row(children: [
                              Expanded(
                                flex: 65,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          //_TimeRow(booking),
                                        ],
                                      ),
                                      //_WorkspaceRow(booking),
                                      //_AddressRow(booking),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(flex: 35, child: Container()),
                            ]),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}


void _showSimpleDialog(BuildContext contextDialog, User user) {
  showDialog(
      context: contextDialog,
      builder: (context) {
        return BlocProvider.value(
          value: BlocProvider.of<PeopleBloc>(contextDialog),
          child: SimpleDialog(
            title: Text(
              user.fullName,
              style: appThemeData.textTheme.headlineSmall
                  ?.copyWith(color: appThemeData.primaryColor),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    contextDialog,
                    MaterialPageRoute(builder: (contextBuilder) {
                      return BlocProvider<ComplaintBloc>(
                        create: (contextBuilder) =>
                            ComplaintBloc()..add(ComplaintStartingEvent(user)),
                        child: const FeedbackUserComplaint(),
                      );
                    }),
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.report_gmailerrorred),
                    const SizedBox(width: 10),
                    Text('Пожаловаться',
                        style: appThemeData.textTheme.titleMedium),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // TODO сделать пользователя избранным
                  if (!user.isFavorite) {
                    contextDialog
                        .read<PeopleBloc>()
                        .add(PeopleAddingToFavoriteEvent(user));
                    Navigator.pop(context);
                  } else {
                    // TODO удалить из избранных
                    contextDialog
                        .read<PeopleBloc>()
                        .add(PeopleRemoveFromFavoriteEvent(user));
                    Navigator.pop(context);
                  }
                },
                child: Row(
                  children: [
                    if (user.isFavorite) ...[
                      const Icon(Icons.star),
                      const SizedBox(width: 10),
                      Text('Убрать из избранного',
                          style: appThemeData.textTheme.titleMedium),
                    ] else ...[
                      const Icon(
                        Icons.star_border,
                      ),
                      const SizedBox(width: 10),
                      Text('Добавить в избранные',
                          style: appThemeData.textTheme.titleMedium),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
