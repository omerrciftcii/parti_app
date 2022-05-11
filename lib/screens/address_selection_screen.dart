import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parti_app/providers/event_provider.dart';
import 'package:parti_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class AddressSelectionScreen extends StatefulWidget {
  final LatLng currentLocation;

  const AddressSelectionScreen({Key? key, required this.currentLocation})
      : super(key: key);

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = new Set();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  late CameraPosition _currentLocation;

  // static final  _currentLocation = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);
  @override
  void initState() {
    _currentLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: widget.currentLocation,
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventProvider>(context);
    return Scaffold(
      bottomSheet: Container(
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: CustomButton(
                backgroundColor: Colors.orange[700],
                text: 'OK',
                textStyle: GoogleFonts.jost(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: CustomButton(
                backgroundColor: Colors.orange[700],
                text: 'USE CURRENT LOCATION',
                textStyle: GoogleFonts.jost(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _currentLocation,
            onMapCreated: (controller) => controller = controller,
            markers: markers,
            onLongPress: (location) async {
              print('');
              setUpMarker(location.latitude, location.longitude);
              eventProvider.selectedLocation = location;
              List<Placemark> placemarks = await placemarkFromCoordinates(
                  location.latitude, location.longitude);
              eventProvider.addressController.text =
                  placemarks.first.street ?? 'Unknown';
            },
          )
        ],
      ),
    );
  }

  setUpMarker(double? latitude, double? longitude) async {
    markers.clear();
    var pickupMarker;
    if (latitude != null && longitude != null) {
      final pickupMarker = Marker(
        markerId: MarkerId("${latitude}"),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/icons/picker.png', 150),
        ),
        infoWindow: InfoWindow(
          title: 'Selected location',
        ),
      );

      markers.add(pickupMarker);
    }
    setState(() {});
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);

    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
