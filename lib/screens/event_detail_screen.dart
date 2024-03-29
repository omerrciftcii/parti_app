import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/models/event_model.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/providers/event_provider.dart';
import 'package:parti_app/screens/chat_detail_screen.dart';
import 'package:parti_app/services/event_service.dart';
import 'package:parti_app/ui_helpers/expandable_fab.dart';
import 'package:parti_app/utils/datetime_helper.dart';
import 'package:parti_app/widgets/comments_widget.dart';
import 'package:parti_app/widgets/custom_button.dart';
import 'package:parti_app/widgets/custom_divider.dart';
import 'package:parti_app/widgets/custom_textfield.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/waiting_indicator.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventID;

  const EventDetailScreen({Key? key, required this.eventID}) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    var eventProvider = Provider.of<EventProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      eventProvider.commnetsTabController =
          TabController(vsync: this, length: 2, initialIndex: 0);

      eventProvider.commnetsTabController.addListener(() {
        eventProvider.selectedTabIndex =
            eventProvider.commnetsTabController.index;
      });
      eventProvider.eventDetailFuture =
          EventService.getEventDetail(widget.eventID);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eventProviider = Provider.of<EventProvider>(context);
    var authProvvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
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
      body: SlidingUpPanel(
        defaultPanelState: PanelState.CLOSED,
        // ignore: prefer_const_constructors

        borderRadius: BorderRadius.circular(24),
        minHeight: 80,

        panel: Column(
          children: [
            Icon(
              Icons.line_weight,
              color: Colors.orange,
            ),
            TabBar(
              controller: eventProviider.commnetsTabController,
              indicatorColor: Colors.transparent,
              tabs: [
                Tab(
                    child: FilterChip(
                  label: Text(
                    'Questions',
                    style: GoogleFonts.jost(color: Colors.black),
                  ),
                  onSelected: (isSelected) {
                    eventProviider.commnetsTabController.index = 0;
                    eventProviider.reviewSelected = false;
                  },
                  selectedColor: Color(0xffD8A64D),
                  selected: !eventProviider.reviewSelected,
                )),
                Tab(
                    child: FilterChip(
                  label: Text(
                    'Reviews',
                    style: GoogleFonts.jost(color: Colors.black),
                  ),
                  onSelected: (isSelected) {
                    eventProviider.commnetsTabController.index = 1;
                    eventProviider.reviewSelected = true;
                  },
                  selected: eventProviider.reviewSelected,
                  selectedColor: Color(0xffD8A64D),
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24),
              child: CustomTextField(
                maxLine: 3,
                controller: eventProviider.commentController,
                hintText: eventProviider.selectedTabIndex == 0
                    ? 'Add your question'
                    : "Add your review",
                validator: (query) {
                  if (query!.isEmpty) {
                    return 'This field cannot be empty';
                  }
                },
                prefixIcon: FaIcon(
                  Icons.reviews_outlined,
                  color: Color(0xffD8A64D),
                ),
                suffixIcon: eventProviider.isWaiting
                    ? CustomWaitingIndicator()
                    : FaIcon(Icons.send_outlined),
                suffixIconPressed: () async {
                  var response = await eventProviider.addComment(
                      eventId: widget.eventID,
                      reviewerName: authProvvider.currentUser!.name,
                      createdById: authProvvider.currentUser!.userId,
                      comment: eventProviider.commentController.text,
                      isReview: eventProviider.commnetsTabController.index == 0
                          ? false
                          : true,
                      reviewerProfilePicture:
                          authProvvider.currentUser?.profilePicture ?? '');

                  eventProviider.commentController.clear();
                  eventProviider.getCommentsFuture = EventService.getComments(
                    eventId: widget.eventID,
                    isReview: eventProviider.commnetsTabController.index == 0
                        ? false
                        : true,
                  );
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: eventProviider.commnetsTabController,
                children: [
                  CommentsWidget(isReview: true, eventId: widget.eventID),
                  CommentsWidget(isReview: false, eventId: widget.eventID),
                ],
              ),
            )
          ],
        ),
        body: FutureBuilder<EventModel>(
            future: eventProviider.eventDetailFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.hasError == false) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      snapshot.data?.eventPicture == null
                          ? CachedNetworkImage(
                              imageUrl: snapshot.data?.eventPicture ??
                                  "https://cdn.pixabay.com/photo/2017/07/21/23/57/concert-2527495__480.jpg",
                              height: 200,
                            )
                          : Image.memory(
                              base64Decode(snapshot.data!.eventPicture ?? ''),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          snapshot.data!.title ?? 'Unknown',
                          style: GoogleFonts.jost(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading:
                                    const Icon(Icons.calendar_today_outlined),
                                title: Text(
                                  DateTimeHelper.getDateTime(
                                    snapshot.data!.startDate ?? DateTime.now(),
                                  ),
                                  style: GoogleFonts.jost(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                subtitle: Text(
                                  DateTimeHelper.getDateTime(
                                    snapshot.data!.endDate ?? DateTime.now(),
                                  ),
                                  style: GoogleFonts.jost(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.location_on_sharp),
                                title: Text(
                                  snapshot.data!.title ?? 'Unknown',
                                  style: GoogleFonts.jost(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                subtitle: Text(
                                  snapshot.data!.address ?? '',
                                  style: GoogleFonts.jost(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const CustomDivider(),
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
                                  imageUrl: snapshot.data?.eventOwnerPicture ??
                                      'https://www.pinclipart.com/picdir/middle/50-506519_text-clipart-free-for-download-unknown-icon-png.png',
                                  width: 40,
                                  height: 40,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      const CustomWaitingIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                title: Text(
                                  snapshot.data?.eventOwnerName ?? 'Unknown',
                                  style: GoogleFonts.jost(
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    pushNewScreen(context,
                                        screen: Chat(
                                            currentUserId: authProvvider
                                                .currentUser!.userId,
                                            name:
                                                snapshot.data!.eventOwnerName ??
                                                    '',
                                            profileUrl: authProvvider
                                                    .currentUser!
                                                    .profilePicture ??
                                                '',
                                            peerAvatar: snapshot
                                                    .data!.eventOwnerPicture ??
                                                '',
                                            peerId:
                                                snapshot.data!.eventOwnerId ??
                                                    '',
                                            surname: 'aasd'),
                                        withNavBar: false);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 24.0),
                                    child: Icon(
                                      Icons.message_outlined,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: GestureDetector(
                          onTap:
                              //  snapshot.data!.participiants
                              //         .contains(authProvvider.currentUser!.userId)
                              //     ? null
                              //     :

                              () async {
                            var result = await eventProviider.joinParty(
                                address:
                                    snapshot.data?.address ?? 'Unknown Address',
                                dateTime: DateTimeHelper.getDateTime(
                                  snapshot.data?.startDate ?? DateTime.now(),
                                ),
                                eventTitle: snapshot.data?.title ?? 'Unknown',
                                partyOwnerName:
                                    snapshot.data!.eventOwnerName ?? 'Unknown',
                                place: snapshot.data!.address ?? 'Uknon',
                                eventDescription:
                                    snapshot.data!.description ?? '',
                                eventId: snapshot.data!.eventId ?? '',
                                participiantId:
                                    authProvvider.currentUser!.userId,
                                participiants: snapshot.data!.participiants,
                                attents:
                                    authProvvider.currentUser!.attents ?? [],
                                participantName:
                                    authProvvider.currentUser!.name);

                            if (result == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Your invitation has been registered. Please check your inbox',
                                    style:
                                        GoogleFonts.jost(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              var currentUser = authProvvider.currentUser;
                              currentUser!.attents ??= [];
                              currentUser.attents!
                                  .add(snapshot.data!.eventId ?? '');
                              authProvvider.currentUser = currentUser;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Your invitation has been registered. Please check your inbox',
                                    style: GoogleFonts.jost(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: eventProviider.isWaiting
                              ? const Center(
                                  child: CustomWaitingIndicator(),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24.0, right: 24),
                                  child: CustomButton(
                                    backgroundColor: Colors.orange,
                                    text: snapshot.data!.participiants.contains(
                                            authProvvider.currentUser!.userId)
                                        ? 'You are going to this party'
                                        : 'Join The Party',
                                    textStyle: GoogleFonts.jost(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: const CustomWaitingIndicator(),
                );
              } else {
                return const Center(
                  child: const Text('An error has occured'),
                );
              }
            }),
      ),
    );
  }
}
