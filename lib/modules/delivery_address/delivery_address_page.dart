import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  // Import dotenv

import '../../theme/colors_theme.dart';
import 'delivery_address_controller.dart';

class DeliveryAddressPage extends StatefulWidget {
  const DeliveryAddressPage({Key? key}) : super(key: key);

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  late DeliveryAddressController deliveryAddressController;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isMapLoading = true;
  bool _isMapInitialized = false;
  final TextEditingController _searchController = TextEditingController();
  late final GoogleMapsPlaces _places;
  LatLng _defaultLocation = LatLng(19.0760, 72.8777);

  @override
  void initState() {
    super.initState();
    deliveryAddressController = Get.find<DeliveryAddressController>();
    _places = GoogleMapsPlaces(apiKey: dotenv.env['GOOGLE_MAPS_API_KEY']);
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      var status = await Permission.location.status;
      if (status.isDenied) {
        await Permission.location.request();
      }
      setState(() {
        _isMapLoading = false;
      });
    } catch (e) {
      print('Error initializing map: $e');
      setState(() {
        _isMapLoading = false;
      });
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;
    if (!_isMapInitialized || _mapController == null) {
      Get.snackbar(
        'Error',
        'Map is not ready yet. Please wait a moment.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ThemeColor.red,
        colorText: ThemeColor.white,
      );
      return;
    }

    try {
      PlacesSearchResponse response = await _places.searchByText(query);
      if (response.results.isNotEmpty) {
        var place = response.results.first;
        LatLng location = LatLng(place.geometry!.location.lat, place.geometry!.location.lng);
        
        setState(() {
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId('selectedLocation'),
              position: location,
              draggable: true,
              onDragEnd: (LatLng newPosition) {
                _updateAddressFromPosition(newPosition);
              },
            ),
          );
        });

        await _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(location, 15),
        );

        _updateAddressFromPosition(location);
      }
    } catch (e) {
      print('Error searching location: $e');
      Get.snackbar(
        'Error',
        'Failed to search location',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ThemeColor.red,
        colorText: ThemeColor.white,
      );
    }
  }

  Future<void> _updateAddressFromPosition(LatLng position) async {
    try {
      // Perform a text search based on the latitude and longitude
      PlacesSearchResponse searchResponse = await _places.searchByText(
        '${position.latitude}, ${position.longitude}', // Use the lat-lng as a query
      );

      if (searchResponse.results.isNotEmpty) {
        // Get the first result's place ID
        String placeId = searchResponse.results.first.placeId;

        // Now use the place ID to get detailed information
        PlacesDetailsResponse response = await _places.getDetailsByPlaceId(placeId);

        if (response.result != null) {
          String address = response.result.formattedAddress ?? '';
          setState(() {
            deliveryAddressController.addressTxtEdtCtrl.text = address;
          });
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get address details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ThemeColor.red,
        colorText: ThemeColor.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: ThemeColor.black,
          ),
        ),
        centerTitle: false,
        title: Text(
          "Delivery Address",
          style: TextStyle(
            color: ThemeColor.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: ThemeColor.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: ThemeColor.white,
      body: SafeArea(
        child: Obx(
          () => deliveryAddressController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: ThemeColor.accent,
                    strokeWidth: 3,
                  ),
                )
              : Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeColor.grey_100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search for a location',
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: _searchLocation,
                        ),
                      ),
                    ),
                    // Map Section
                    Expanded(
                      child: _isMapLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: ThemeColor.accent,
                                strokeWidth: 3,
                              ),
                            )
                          : GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: _defaultLocation,
                                zoom: 12,
                              ),
                              markers: _markers,
                              onMapCreated: (GoogleMapController controller) {
                                setState(() {
                                  _mapController = controller;
                                  _isMapInitialized = true;
                                });
                              },
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              zoomControlsEnabled: false,
                              onTap: (LatLng position) async {
                                if (!_isMapInitialized) return;
                                
                                setState(() {
                                  _markers.clear();
                                  _markers.add(
                                    Marker(
                                      markerId: MarkerId('selectedLocation'),
                                      position: position,
                                      draggable: true,
                                      onDragEnd: (LatLng newPosition) {
                                        _updateAddressFromPosition(newPosition);
                                      },
                                    ),
                                  );
                                });
                                _updateAddressFromPosition(position);
                              },
                            ),
                    ),
                    // Address Section
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delivery Address",
                            style: TextStyle(
                              fontSize: 18,
                              color: ThemeColor.textPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: ThemeColor.grey_100,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: deliveryAddressController.addressTxtEdtCtrl,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                color: ThemeColor.black,
                                fontSize: 14,
                              ),
                              maxLines: 3,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(16),
                                hintText: "Write your delivery address",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: ThemeColor.grey_600,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                if (deliveryAddressController.addressTxtEdtCtrl.text.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Please select a delivery address',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: ThemeColor.red,
                                    colorText: ThemeColor.white,
                                  );
                                  return;
                                }
                                deliveryAddressController.updateAddress();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeColor.primaryDark,
                                foregroundColor: ThemeColor.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: Text("Use this address"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
