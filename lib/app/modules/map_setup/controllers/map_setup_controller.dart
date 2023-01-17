import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSetupController extends GetxController {
  late Position position;
  final Rx<LatLng> sourceLocation = const LatLng(-8, 115).obs;
  late StreamSubscription<Position> positionStream;

  @override
  void onInit() {
    _determinePosition();
    getLocation();
    updateLocation();
    super.onInit();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // sourceLocation.value = LatLng(position.latitude, position.longitude);
    return position;
  }

  // positionStream = Geolocator.getPositionStream(
  //         locationSettings:
  //             const LocationSettings(accuracy: LocationAccuracy.best))
  //     .listen((Position? position) {
  //   print(position == null
  //       ? 'Unknown'
  //       : '${position.latitude.toString()}, ${position.longitude.toString()}');
  // });
  updateLocation() {
    positionStream = Geolocator.getPositionStream(locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.best))
        .listen((Position? position) {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
          postData();
    });
  }
  postData() async {
    final postData = FirebaseFirestore.instance.collection('live_location').doc('freddy_location');
    final jsonData = {
      'latlong': [position.latitude, position.longitude],
    };
    await postData
        .update(jsonData)
        .then((value) => print("upadate latlong berhasil!"))
        .catchError(
            (error) => print("update location : $error"));
  }

  getLocation()async {
    // Stream getData = FirebaseFirestore.instance.collection('live_location').doc('gilang_location').snapshots();
    // // sourceLocation.value = 
    
    // var test = jsonEncode(getData);
    // // print('Source Location : ${sourceLocation.toString()}');
    // print('Get Data : ${test.toString()}');

    final docRef = FirebaseFirestore.instance.collection('live_location').doc('gilang_location');
    docRef.get().then(
      (DocumentSnapshot doc) {
        GeoPoint data = doc.data() as GeoPoint;
        // double lat = data.ge;
        // double lng = data.getLongitude();
        // LatLng latLng = new LatLng(lat, lng);
        print('Get Data : ${data.toString()}');
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
}
