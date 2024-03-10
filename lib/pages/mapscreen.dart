import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final String address;
  const MapScreen({super.key, required this.address});
  @override
  _MapScreenState createState() => _MapScreenState();
}

Future<void> Wait() async {
  EasyLoading.show(status: 'loading...');
  await Future.delayed(Duration(seconds: 1));
  EasyLoading.dismiss();
}

class _MapScreenState extends State<MapScreen> {
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    getLocationFromAddress();
    // Wait();
  }

  Future<void> getLocationFromAddress() async {
    try {
      List<Location> locations = await locationFromAddress(widget.address);
      setState(() {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                text: const TextSpan(
                    text: 'Location of Item',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold))),
            SizedBox(height: 16),
            if (latitude != null && longitude != null) ...[
              Container(
                height: 300,
                width: double.infinity,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(latitude!, longitude!),
                    zoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () => launchUrl(
                              Uri.parse('https://openstreetmap.org/copyright')),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ] else if (latitude == null && longitude == null) ...[
              const CircularProgressIndicator(),
            ]
          ],
        ),
      ),
    );
  }
}
