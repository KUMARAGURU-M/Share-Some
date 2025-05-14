import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNotificationEnabled = true;

  LatLng myCurrentLocation = const LatLng(11.9416, 79.8083);

  late GoogleMapController googleMapController;
  Set<Marker> markers = {};

  // Mock data simulating fetched Firebase data
  List<Map<String, String>> mockData = [
    {
      'homeName': 'Anugraham Home',
      'distance': '1.2 km',
      'title': 'Requesting Lunch for 69 senior persons',
      'description':
          'Lorem ipsum dolor sit amet, consectetuer sociis natoque penatibus et magnis.',
    },
    {
      'homeName': 'Anugraham Home',
      'distance': '5.0 km',
      'title': 'Requesting Lunch for 69 senior persons',
      'description':
          'Lorem ipsum dolor sit amet, consectetuer sociis natoque penatibus et magnis.',
    },
    {
      'homeName': 'Anugraham Home',
      'distance': '5.0 km',
      'title': 'Requesting Lunch for 69 senior persons',
      'description':
          'Lorem ipsum dolor sit amet, consectetuer sociis natoque penatibus et magnis.',
    },
    {
      'homeName': 'Anugraham Home',
      'distance': '5.0 km',
      'title': 'Requesting Lunch for 69 senior persons',
      'description':
          'Lorem ipsum dolor sit amet, consectetuer sociis natoque penatibus et magnis.',
    },
    // Additional mock data entries
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Back',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height *
                  0.5, // Reduce to 1/2 of the screen
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: GoogleMap(
                  myLocationButtonEnabled: false,
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: myCurrentLocation,
                    zoom: 14,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var request = mockData[index];
                  String homeName = request['homeName'] ?? '';
                  String distance = request['distance'] ?? '';
                  String title = request['title'] ?? '';
                  String description = request['description'] ?? '';

                  return Container(
                    margin: const EdgeInsets.all(11),
                    padding: const EdgeInsets.fromLTRB(16, 17, 16, 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        const BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 10,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row with Home Name and Distance
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              homeName,
                              style: const TextStyle(
                                color: Color(0xFFFC8019),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/delivery.svg',
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  distance,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.33,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(
                            color: Color(0xFF9AA2AB),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFC8019),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFFC8019)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: const Size(160, 50),
                                padding: EdgeInsets.zero,
                              ),
                              icon: const Icon(
                                Icons.call,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  'Call Recipient',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                childCount: mockData.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
