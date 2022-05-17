import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/providers/event_provider.dart';
import 'package:parti_app/providers/home_provider.dart';
import 'package:parti_app/screens/address_selection_screen.dart';
import 'package:parti_app/widgets/custom_button.dart';
import 'package:parti_app/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

import '../widgets/waiting_indicator.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({Key? key}) : super(key: key);

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  @override
  void initState() {
    var eventProvider = Provider.of<EventProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      eventProvider.addressController.clear();
      eventProvider.isHomeParty = true;
      eventProvider.selectedEndDate = DateTime.now();
      eventProvider.selectedStartDate = DateTime.now();
      eventProvider.maxParticipiantController.clear();
      eventProvider.selectedLocation = null;
      eventProvider.selectedEventPicture = null;
      eventProvider.titleController.clear();
      eventProvider.descriptionController.clear();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    var homeProvider = Provider.of<HomeProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        print('sfafdf');
        return true;
      },
      child: Scaffold(
        bottomSheet: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24),
          child: SizedBox(
            height: 50,
            child: eventProvider.isWaiting
                ? Center(child: CustomWaitingIndicator())
                : Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          backgroundColor: Color(0x80AC3AA1),
                          text: 'Cancel',
                          textStyle: GoogleFonts.jost(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        width: 28,
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () async {
                            if (eventProvider.formKey.currentState!
                                .validate()) {
                              var response = await eventProvider.createEvent(
                                  authProvider.currentUser!.userId,
                                  authProvider.currentUser?.name ?? '',
                                  authProvider.currentUser?.profilePicture ??
                                      '');
                              if (response != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Event created successfully'),
                                  ),
                                );

                                Navigator.pop(context);
                              }
                            }
                          },
                          child: CustomButton(
                            backgroundColor: Color(0xffAC3AA1),
                            text: 'Create Event',
                            textStyle: GoogleFonts.jost(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: eventProvider.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 72,
                ),
                Center(
                  child: Text(
                    'Create Your Own Party!',
                    style: GoogleFonts.jost(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, bottom: 12, top: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: FilterChip(
                                label: Text('Club Party'),
                                onSelected: (_) {
                                  eventProvider.isHomeParty = false;
                                },
                                selected: !eventProvider.isHomeParty,
                                selectedColor: Color(0xffD8A64D)),
                          ),
                          Expanded(
                            flex: 10,
                            child: FilterChip(
                              label: Text('Home Party'),
                              onSelected: (_) {
                                eventProvider.isHomeParty = true;
                              },
                              selectedColor: Color(0xffD8A64D),
                              selected: eventProvider.isHomeParty,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 10,
                            ),
                          ),
                        ],
                      ),
                      CustomTextField(
                        controller: eventProvider.titleController,
                        hintText: 'Party Name',
                        validator: (query) {
                          if (query!.length < 10) {
                            return 'Party name should be at least 10 characters';
                          } else if (query.length > 50) {
                            return 'Party name cannot be more than 50 characters';
                          }
                        },
                      ),
                      CustomTextField(
                        controller: eventProvider.descriptionController,
                        hintText: 'Description',
                        validator: (query) {
                          if (query!.length < 100) {
                            return 'Description should be at least 100 characters';
                          } else if (query.length > 1000) {
                            return 'Description cannot be more than 50 characters';
                          }
                        },
                      ),
                      CSCPicker(
                        dropdownDecoration: BoxDecoration(
                          color: Color(0x90D8A64D),
                        ),
                        showStates: true,
                        onCountryChanged: (value) {
                          eventProvider.currentCountry = value;
                        },
                        onStateChanged: (value) {
                          eventProvider.currentState = value;
                        },
                        onCityChanged: (value) {
                          eventProvider.currentCity = value;
                        },
                      ),
                      // SelectState(
                      //   style: GoogleFonts.jost(),
                      //   onCountryChanged: (value) {
                      //     eventProvider.currentCountry = value;
                      //   },
                      //   onStateChanged: (value) {
                      //     eventProvider.currentState = value;
                      //   },
                      //   onCityChanged: (value) {
                      //     eventProvider.currentCity = value;
                      //   },
                      // ),
                      // InkWell(
                      //   onTap:(){
                      //     print('country selected is $countryValue');
                      //     print('country selected is $stateValue');
                      //     print('country selected is $cityValue');
                      //   },
                      //   child: Text(' Check')
                      // )
                      CustomTextField(
                        controller: eventProvider.addressController,
                        readOnly: false,
                        hintText: 'Address',
                        validator: (address) {
                          if (address!.isEmpty) {
                            return 'Addres must be selected';
                          }
                        },
                        suffixIcon: FaIcon(Icons.navigation_rounded),
                        suffixIconPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddressSelectionScreen(
                                  currentLocation: LatLng(
                                      homeProvider.currentPosition!.latitude ??
                                          0,
                                      homeProvider.currentPosition!.longitude ??
                                          0)),
                            ),
                          );
                        },
                      ),
                      CustomTextField(
                        readOnly: true,
                        controller: eventProvider.startDateController,
                        hintText: 'Starting Date',
                        validator: (address) {
                          if (address!.isEmpty) {
                            return 'Start date must be selected';
                          }
                        },
                        suffixIcon: FaIcon(Icons.date_range),
                        suffixIconPressed: () async {
                          await eventProvider.selectDate(context, true);
                        },
                      ),
                      CustomTextField(
                        readOnly: true,
                        controller: eventProvider.endDateController,
                        hintText: 'End Date',
                        validator: (address) {
                          if (address!.isEmpty) {
                            return 'End date must be selected';
                          }
                        },
                        suffixIcon: FaIcon(Icons.date_range),
                        suffixIconPressed: () async {
                          await eventProvider.selectDate(context, false);
                        },
                      ),
                      CustomTextField(
                        readOnly: false,
                        inputType: TextInputType.number,
                        controller: eventProvider.maxParticipiantController,
                        hintText: 'Max Participiants',
                        validator: (address) {
                          if (address!.isEmpty) {
                            return 'Max Participiants must be selected';
                          }
                        },
                        suffixIcon: FaIcon(Icons.people_sharp),
                        suffixIconPressed: () async {
                          await eventProvider.selectDate(context, false);
                        },
                      ),
                      CustomTextField(
                        readOnly: true,
                        controller: eventProvider.imageController,
                        hintText: 'Add Your Party Image (Optional)',
                        validator: (image) {},
                        suffixIcon: FaIcon(Icons.image),
                        suffixIconPressed: () async {
                          await eventProvider.pickImage();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
