import 'dart:convert';

import 'package:flutter/material.dart';

import '../styles/text_style.dart';
import '../utils/ui_helper.dart';

class EventCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String location;
  final String image;
  const EventCard(
      {Key? key,
      required this.onTap,
      required this.title,
      required this.location,
      required this.image})
      : super(key: key);

  get imgBG => null;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            buildImage(),
            buildEventInfo(context),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: imgBG,
        width: 80,
        height: 100,
        child: image == ''
            ? Image.network(
                "https://www.pinclipart.com/picdir/middle/50-506519_text-clipart-free-for-download-unknown-icon-png.png",
                fit: BoxFit.contain,
              )
            : Image.memory(
                base64Decode(image),
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget buildEventInfo(context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('03.03.2022'),
          UIHelper.verticalSpace(8),
          Text(title, style: titleStyle),
          UIHelper.verticalSpace(8),
          Row(
            children: <Widget>[
              Icon(Icons.location_on,
                  size: 16, color: Theme.of(context).primaryColor),
              UIHelper.horizontalSpace(4),
              Text(location, style: subtitleStyle),
            ],
          ),
        ],
      ),
    );
  }
}
