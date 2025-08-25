import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedAddress;
  bool _fetching = false;

  @override
  void initState() {
    super.initState();
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    _selectedAddress = locationProvider.currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final addresses = _searchQuery.isEmpty
        ? locationProvider.savedAddresses
        : locationProvider.searchAddresses(_searchQuery);
    final currentLocation = locationProvider.currentLocation;

    return Scaffold(
      appBar: AppBar(title: const Text('My Location')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextField(
            //   controller: _searchController,
            //   decoration: const InputDecoration(hintText: 'Search address...'),
            //   onChanged: (value) {
            //     setState(() {
            //       _searchQuery = value;
            //     });
            //   },
            // ),
            //const SizedBox(height: 16),

            const Text(
              'Saved Addresses:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Expanded(
            //   child: addresses.isEmpty
            //       ? const Center(child: Text('No saved addresses yet.'))
            //       : ListView.builder(
            //           itemCount: addresses.length,
            //           itemBuilder: (context, index) {
            //             final address = addresses[index];
            //             final isSelected = address == _selectedAddress;

            //             return Card(
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(16),
            //               ),
            //               //elevation: 1,
            //               color: isSelected ? Colors.white : null,
            //               elevation: isSelected ? 4 : 1,
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                   color: Colors.white,
            //                   borderRadius: BorderRadius.circular(16),
            //                 ),

            //                 //child: Container(
            //                 //color: Colors.white,
            //                 child: ListTile(
            //                   leading: Icon(
            //                     isSelected
            //                         ? Icons.radio_button_checked
            //                         : Icons.radio_button_unchecked,
            //                     color: Colors.green,
            //                   ),
            //                   title: Text(
            //                     address,
            //                     style: TextStyle(
            //                       fontWeight: isSelected
            //                           ? FontWeight.bold
            //                           : FontWeight.normal,
            //                     ),
            //                     maxLines: 2,
            //                     overflow: TextOverflow.ellipsis,
            //                   ),
            //                   trailing: IconButton(
            //                     icon:
            //                         const Icon(Icons.delete, color: Colors.red),
            //                     onPressed: () =>
            //                         locationProvider.removeAddress(address),
            //                   ),
            //                   onTap: () {
            //                     setState(() {
            //                       _selectedAddress = address;
            //                     });
            //                   },
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            // ),
            Expanded(
              child: addresses.isEmpty
                  ? const Center(child: Text('No saved addresses'))
                  : ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final fullAddress = addresses[index];
                        final isSelected = fullAddress == _selectedAddress;

                        // Split into location name and address
                        final parts = fullAddress.split(':');
                        final locationName =
                            parts.length > 1 ? parts[0].trim() : 'Location';
                        final addressLine =
                            parts.length > 1 ? parts[1].trim() : fullAddress;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: isSelected ? Colors.white : null,
                          elevation: isSelected ? 4 : 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: Colors.green,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    locationName, // Home / Work / etc
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  //const SizedBox(height: 2),
                                  Text(
                                    addressLine, // 123 ABC Street, Delhi
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    locationProvider.removeAddress(fullAddress),
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedAddress = fullAddress;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.my_location),
              label: Text(_fetching ? '' : 'Use Current Location'),
              onPressed: _fetching
                  ? null
                  : () async {
                      setState(() => _fetching = true);
                      await locationProvider.fetchCurrentLocation();
                      setState(() {
                        _selectedAddress = locationProvider.lastFetchedAddress;
                        _fetching = false;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 255, 243, 228), 
                foregroundColor: Colors.orange, 
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add New Location'),
              onPressed: locationProvider.lastFetchedAddress == null
                  ? null
                  : () {
                      Navigator.pushNamed(
                        context,
                        '/add-address',
                        arguments: locationProvider.lastFetchedAddress,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 255, 243, 228), 
                foregroundColor: Colors.orange, 
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _selectedAddress == null
                  ? null
                  : () {
                      locationProvider.setCurrentLocation(_selectedAddress!);
                      Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
