import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AddedFeedbackPeopleCard extends StatelessWidget {
  final User user;

  const AddedFeedbackPeopleCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      // чтоб обрезал края при нажатии на карт
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              leading: Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: AppImageProvider.getImageUrlFromImageId(
                              user.avatarImageId),
                          httpHeaders: NetworkController().getAuthHeader(),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress)),
                          errorWidget: (context, url, error) => Container()),
                    ),
                  ),
                ),
              ]),
              title: Text(user.fullName),
              subtitle: Text(
                user.email,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
