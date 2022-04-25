import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:parti_app/models/comment_model.dart';
import 'package:parti_app/providers/event_provider.dart';
import 'package:parti_app/services/event_service.dart';
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
              itemBuilder: (BuildContext context, int index) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UserDetailsWithFollow(
                    key:
                        ValueKey("${CommentsListKeyPrefix.commentUser} $index"),
                    userData: commentData.user,
                  ),
                  Text(
                    commentData.comment,
                    key:
                        ValueKey("${CommentsListKeyPrefix.commentText} $index"),
                    textAlign: TextAlign.left,
                  ),
                  Divider(
                    key: ValueKey(
                        "${CommentsListKeyPrefix.commentDivider} $index"),
                    color: Colors.black45,
                  ),
                ],
              ),
            );
          });
        }
      },
    );
  }
}
