import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSetupController extends GetxController with WidgetsBindingObserver {
  late Position position;
  final Rx<LatLng> sourceLocation =
      const LatLng(-8.642612058029062, 115.20457939080391).obs;
  late GoogleMapController mapController;

  late BitmapDescriptor customIcon;
  late Uint8List markerIcon;

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
    WidgetsBinding.instance.addObserver(this);
    // getLocation();
    // updateLocation();
    iconMarker();
    timer =
        Timer.periodic(const Duration(seconds: 2), (Timer t) => getLocation());

    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    timer!.cancel();
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
    return position;
  }

  @override
  void refresh() async {
    isLoad.value = false;
    isLoad.value = true;
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

  addMarker(String id, LatLng location) async {
    mark.add(
      Marker(
        markerId: MarkerId(id),
        position: location,
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ),
    );
  }

  iconMarker() async {
    markerIcon = await getBytesFromAsset('assets/fd.png', 100);
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        timer = Timer.periodic(
            const Duration(seconds: 2), (Timer t) => getLocation());
        break;
      case AppLifecycleState.inactive:
        timer = Timer.periodic(
            const Duration(seconds: 2), (Timer t) => getLocation());
        break;
      case AppLifecycleState.paused:
        timer = Timer.periodic(
            const Duration(seconds: 2), (Timer t) => getLocation());
        break;
      case AppLifecycleState.detached:
        timer = Timer.periodic(
            const Duration(seconds: 2), (Timer t) => getLocation());
        break;
    }
  }
}
