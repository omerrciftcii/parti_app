import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/widgets/custom_divider.dart';

import '../ui_helpers/expandable_fab.dart';

class EventDetailScreen extends StatelessWidget {
  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(''),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  const EventDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Party',
          style: GoogleFonts.jost(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 90.0,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(
              Icons.person_add_alt_outlined,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(
              Icons.map,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CachedNetworkImage(
              imageUrl:
                  "https://cdn.pixabay.com/photo/2017/07/21/23/57/concert-2527495__480.jpg"),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              "Şamxal Bağışov's Home Party",
              style:
                  GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.calendar_today_outlined),
                    title: Text(
                      'Wednesday, April 12, 2022',
                      style: GoogleFonts.jost(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    subtitle: Text(
                      '19:00 - 21:00 GMT+03:00',
                      style: GoogleFonts.jost(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomDivider(),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.location_on_sharp),
                    title: Text(
                      'Water Garden',
                      style: GoogleFonts.jost(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    subtitle: Text(
                      'Barbaros, Kızılbegonya Sok 10/1',
                      style: GoogleFonts.jost(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomDivider(),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              'Party Owner',
              style: GoogleFonts.jost(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CachedNetworkImage(
                      imageUrl: "https://i.postimg.cc/DwS9kKFX/Shmakha.png",
                      imageBuilder: (context, imageProvider) => Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(
                      'Şamxal Bağışov',
                      style: GoogleFonts.jost(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
