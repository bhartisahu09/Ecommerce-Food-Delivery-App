import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(28.6139, 77.2090); // Default: Delhi
  bool _loading = true;

  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permissions denied.');
      }
    }

    final Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    await _getAddressFromLatLng(_currentPosition);
    setState(() => _loading = false);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        _addressController.text =
            "${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      _addressController.text = "Unable to fetch address";
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentPosition = position.target;
  }

  void _onCameraIdle() {
    _getAddressFromLatLng(_currentPosition);
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentPosition,
                            zoom: 16,
                          ),
                          myLocationEnabled: true,
                          onMapCreated: (controller) => mapController = controller,
                          onCameraMove: _onCameraMove,
                          onCameraIdle: _onCameraIdle,
                        ),
                        const Center(
                          child: Icon(Icons.location_on, size: 40, color: Colors.orange),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: _fetchLocation,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              hintText: "Enter address",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _locationNameController,
                            decoration: const InputDecoration(
                              hintText: "e.g. Home, Office, Friend's house",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              if (_locationNameController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Enter location name')),
                                );
                                return;
                              }

                              final fullAddress =
                                  "${_locationNameController.text.trim()}: ${_addressController.text.trim()}";
                              locationProvider.addAddress(fullAddress);
                              Navigator.pop(context);
                            },
                            child: const Text('Save', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}






//-----------------------------------------
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class AddAddressScreen extends StatefulWidget {
//   const AddAddressScreen({super.key});

//   @override
//   State<AddAddressScreen> createState() => _AddAddressScreenState();
// }

// class _AddAddressScreenState extends State<AddAddressScreen> {
//   GoogleMapController? _mapController;
//   LatLng? _currentLatLng;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserLocation();
//   }

//   Future<void> _fetchUserLocation() async {
//     final Location location = Location();

//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) serviceEnabled = await location.requestService();

//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//     }

//     if (permissionGranted == PermissionStatus.granted) {
//       final userLocation = await location.getLocation();
//       setState(() {
//         _currentLatLng = LatLng(userLocation.latitude!, userLocation.longitude!);
//         _loading = false;
//       });
//     }
//   }

//   void _onCameraMove(CameraPosition position) {
//     _currentLatLng = position.target;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add New Location')),
//       body: _loading || _currentLatLng == null
//           ? const Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                     target: _currentLatLng!,
//                     zoom: 16,
//                   ),
//                   onMapCreated: (controller) => _mapController = controller,
//                   onCameraMove: _onCameraMove,
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: true,
//                 ),
//                 // Center marker
//                 const Center(
//                   child: Icon(Icons.location_on, size: 40, color: Colors.orange),
//                 ),
//                 // Bottom Sheet
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     margin: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Confirm Location',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.orange,
//                             minimumSize: const Size.fromHeight(48),
//                           ),
//                           onPressed: () {
//                             // Here, _currentLatLng will have the selected location
//                             Navigator.pop(context, _currentLatLng);
//                           },
//                           child: const Text("Save", style: TextStyle(color: Colors.white)),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//     );
//   }
// }
