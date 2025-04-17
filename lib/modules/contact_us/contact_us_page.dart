import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/colors_theme.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  late GoogleMapController _mapController;
  final LatLng _storeLocation = LatLng(19.1002972, 72.8900272);
  final String _storeAddress = "Khodiar Niwas, near Anjuman School, Tilak Nagar, Mumbai, Maharashtra 400076";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ThemeColor.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            "Contact Us",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ThemeColor.black),
          ),
          centerTitle: false,
          backgroundColor: ThemeColor.white,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        backgroundColor: ThemeColor.grey_50,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Map Section
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: ThemeColor.grey_400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _storeLocation,
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('storeLocation'),
                          position: _storeLocation,
                          infoWindow: InfoWindow(
                            title: 'Natural Food Mall',
                            snippet: _storeAddress,
                          ),
                        ),
                      },
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
                      myLocationEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Store Address
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ThemeColor.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Visit Our Store",
                        style: TextStyle(
                          color: ThemeColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _storeAddress,
                        style: TextStyle(
                          color: ThemeColor.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${_storeLocation.latitude},${_storeLocation.longitude}');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColor.primaryDark,
                          foregroundColor: ThemeColor.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(double.infinity, 40),
                        ),
                        child: Text("Get Directions"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Contact Cards
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ThemeColor.grey_400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        contactUsCard("Delivery Support", "+91 99200 95657",
                            "support@naturalfoodmall.in"),
                        SizedBox(
                          height: 12,
                        ),
                        contactUsCard("Service Support", "+91 99200 75872",
                            "support@naturalfoodmall.in")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Container contactUsCard(
      String supportName, String supportMobileNumber, String supportEmail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            supportName,
            style: TextStyle(
              color: ThemeColor.black,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            supportMobileNumber,
            style: TextStyle(color: ThemeColor.darkGrey, fontSize: 14),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            supportEmail,
            style: TextStyle(color: ThemeColor.textPrimary, fontSize: 14),
          )
        ],
      ),
    );
  }
}
