import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSetupController extends GetxController {
  late Position position;
  final Rx<LatLng> sourceLocation =
      LatLng(-8.642612058029062, 115.20457939080391).obs;
  late StreamSubscription positionStream;
  late GoogleMapController mapController;

  Map<String, Marker> markers = {};
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;
  RxBool isLoad = false.obs;

  final mark = <Marker>{}.obs;
  final cam = <CameraPosition>{}.obs;
  Timer? timer;

  @override
  void onInit() {
    _determinePosition();
    // getLocation();
    // updateLocation();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getLocation());
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

  updateLocation() {
    positionStream = Geolocator.getPositionStream(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.best))
        .listen((Position? position) {
      lat.value = position!.latitude;
      long.value = position.longitude;

      postData();
    });
  }

  stopLocation() {
    positionStream.cancel();
  }

  void refresh() async {
    isLoad.value = false;
    isLoad.value = true;
  }

  postData() async {
    // print("${lat} , ${long}");
    final postData = FirebaseFirestore.instance
        .collection('live_location')
        .doc('freddy_location');
    final jsonData = {
      'lat': lat.value,
      'long': long.value,
    };
    await postData.update(jsonData);
  }

  getLocation() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("live_location")
        .doc("freddy_location")
        .get();
    var lat = documentSnapshot['lat'];
    var long = documentSnapshot['long'];
    sourceLocation.value = LatLng(lat, long);
    log(sourceLocation.value.toString());
    addMarker("1", sourceLocation.value);
    refresh();
  }

  addMarker(String id, LatLng location) {
    mark.add(
      Marker(
        markerId: MarkerId(id),
        position: location,
        // icon: markerbitmap2,
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
