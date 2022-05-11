import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/models/comment_model.dart';
import 'package:parti_app/providers/event_provider.dart';
import 'package:parti_app/services/event_service.dart';
import 'package:parti_app/utils/datetime_helper.dart';
import 'package:parti_app/widgets/waiting_indicator.dart';
import 'package:provider/provider.dart';

class CommentsWidget extends StatefulWidget {
  final bool isReview;
  final String eventId;
  const CommentsWidget({
    Key? key,
    required this.isReview,
    required this.eventId,
  }) : super(key: key);

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  @override
  void initState() {
    var eventProvider = Provider.of<EventProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      eventProvider.getCommentsFuture = EventService.getComments(
          eventId: widget.eventId, isReview: widget.isReview);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventProvider>(context, listen: false);

    return FutureBuilder<List<CommentModel>>(
      future: eventProvider.getCommentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CustomWaitingIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.hasError == false &&
            snapshot.data!.isNotEmpty) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data![index].reviewerProfilePicture),
                        ),
                        title: Text(
                          snapshot.data![index].reviewerName,
                          style: GoogleFonts.jost(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          DateTimeHelper.getDateTime(
                              snapshot.data![index].createdDate),
                          style: GoogleFonts.jost(color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                          style: GoogleFonts.jost(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                );
              });
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData == true &&
            snapshot.data!.isEmpty &&
            snapshot.error == null) {
          return Center(
            child: Text('There is no comment'),
          );
        } else {
          throw Exception(snapshot.error);
        }
      },
    );
  }
}
