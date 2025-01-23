import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const HospitalMapApp());
}

class HospitalMapApp extends StatelessWidget {
  const HospitalMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HospitalMapScreen(),
    );
  }
}

class HospitalMapScreen extends StatefulWidget {
  const HospitalMapScreen({super.key});

  @override
  State<HospitalMapScreen> createState() => _HospitalMapScreenState();
}

class _HospitalMapScreenState extends State<HospitalMapScreen> {
  GoogleMapController? _mapController;
  final Map<MarkerId, Marker> _hospitalMarkers = {};
  static const LatLng _defaultLocation = LatLng(13.7563, 100.5018);
  CameraPosition _currentPosition = const CameraPosition(
    target: _defaultLocation,
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // ตรวจสอบการอนุญาตการเข้าถึงตำแหน่ง
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog(
        'Location Services Disabled',
        'Please enable location services to use this feature.',
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog(
          'Permission Denied',
          'Location permission is required to use this feature.',
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog(
        'Permission Denied Forever',
        'Location permissions are permanently denied. Please enable permissions from settings.',
      );
      return;
    }

    await _getCurrentLocation();
  }

  // ดึงตำแหน่งปัจจุบัน
  Future<void> _getCurrentLocation() async {
    try {
      // รอรับตำแหน่งปัจจุบัน
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final LatLng currentLatLng =
          LatLng(position.latitude, position.longitude);

      // อัพเดทตำแหน่งบนแผนที่
      setState(() {
        _currentPosition = CameraPosition(target: currentLatLng, zoom: 15);
        _addMarker(
          'current_location',
          currentLatLng,
          'Your Current Location',
          BitmapDescriptor.hueBlue,
        );
      });

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLatLng, zoom: 15),
        ),
      );

      // เรียกฟังก์ชันค้นหาโรงพยาบาลโดยใช้ตำแหน่งปัจจุบัน
      await _fetchNearbyHospitals(currentLatLng);
    } catch (e) {
      _showErrorDialog(
        'Location Error',
        'Could not determine your current location. Please try again.',
      );
    }
  }

  // ดึงข้อมูลโรงพยาบาลจาก backend
  Future<void> _fetchNearbyHospitals(LatLng currentLocation) async {
    const String backendUrl =
        'http://localhost:3000/nearby-hospitals'; // ใช้ backend URL
    try {
      // ใช้ตำแหน่งปัจจุบันในการทำการค้นหาโรงพยาบาล
      final response = await http.get(Uri.parse(
          '$backendUrl?lat=${currentLocation.latitude}&lng=${currentLocation.longitude}'));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}'); // ตรวจสอบเนื้อหาของ response

      if (response.statusCode == 200) {
        final List hospitals = json.decode(response.body);

        print(
            'Parsed JSON Response: $hospitals'); // ตรวจสอบข้อมูลที่ถูกแปลงจาก JSON

        setState(() {
          _hospitalMarkers.clear();
          for (var hospital in hospitals) {
            print('Hospital: ${hospital['name']}'); // ตรวจสอบชื่อโรงพยาบาล
            print(
                'Location: ${hospital['location']}'); // ตรวจสอบตำแหน่งของโรงพยาบาล
            print('Address: ${hospital['address']}'); // ตรวจสอบที่อยู่
            _addMarker(
              hospital['name'],
              LatLng(hospital['location']['lat'], hospital['location']['lng']),
              hospital['address'],
              BitmapDescriptor.hueRed,
            );
          }
        });
      } else {
        _showErrorDialog('Error', 'Failed to fetch hospitals');
      }
    } catch (e) {
      _showErrorDialog('Error', 'Could not connect to the server');
      print('Error: $e'); // ตรวจสอบข้อผิดพลาดในการเชื่อมต่อ
    }
  }

  // เพิ่ม Marker บนแผนที่
  void _addMarker(String id, LatLng position, String info, double colorHue) {
    final MarkerId markerId = MarkerId(id);
    final Marker marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(title: id, snippet: info),
      icon: BitmapDescriptor.defaultMarkerWithHue(colorHue),
    );

    _hospitalMarkers[markerId] = marker;
  }

  // แสดงข้อความผิดพลาด
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ตั้งค่า Map Style
  void _setMapStyle() async {
    if (_mapController != null) {
      final String mapStyle = '''
      [
        {
          "featureType": "poi",
          "stylers": [
            { "visibility": "off" }
          ]
        },
        {
          "featureType": "poi.medical",
          "stylers": [
            { "visibility": "on" }
          ]
        }
      ]
      ''';

      await _mapController!.setMapStyle(mapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _currentPosition,
            mapType: MapType.normal,
            markers: Set<Marker>.of(_hospitalMarkers.values),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _setMapStyle(); // Apply custom map style
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                if (_currentPosition != null) {
                  _fetchNearbyHospitals(_currentPosition.target);
                }
              },
              child: const Icon(Icons.local_hospital),
            ),
          ),
        ],
      ),
    );
  }
}
