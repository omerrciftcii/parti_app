import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:parti_app/models/event_model.dart';

class NewEventCardWidget extends StatelessWidget {
  final EventModel event;
  final double width;
  final double height;

  const NewEventCardWidget(
      {Key? key,
      required this.event,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 160,
      decoration: BoxDecoration(
        // color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: event.eventPicture == null
          ? CachedNetworkImage(
              imageUrl: event.eventPicture ??
                  "https://cdn.pixabay.com/photo/2017/07/21/23/57/concert-2527495__480.jpg",
              height: 160,
              width: 130,
              fit: BoxFit.contain,
            )
          : Image.memory(
              base64Decode(event.eventPicture ?? ''),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
    );
  }
}
