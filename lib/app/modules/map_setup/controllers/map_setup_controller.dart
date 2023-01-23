import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class MapSetupController extends GetxController with WidgetsBindingObserver {
  final Rx<LatLng> sourceLocation =
      const LatLng(-8.642612058029062, 115.20457939080391).obs;
  GoogleMapController? mapController;

  late BitmapDescriptor customIcon;
  late Uint8List markerIcon;

  Map<String, Marker> markers = {};
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;
  RxBool isLoad = false.obs;

  final mark = <Marker>{}.obs;
  final cam = <CameraPosition>{}.obs;
  Timer? timer;

  //location
  loc.Location location = loc.Location();

  @override
  void onInit() {
    requestPermission();
    iconMarker();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    timer =
        Timer.periodic(const Duration(seconds: 2), (Timer t) => getLocation());
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    timer!.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        timer =
        Timer.periodic(const Duration(seconds: 2), (Timer t) => getLocation());
        break;
      case AppLifecycleState.inactive:
        stopGetBackground();
        break;
      case AppLifecycleState.paused:
        stopGetBackground();
        break;
      case AppLifecycleState.detached:
        stopGetBackground();
        break;
    }
  }

  stopGetBackground()async {
    bool bgModeEnabled = await location.isBackgroundModeEnabled();
    if (bgModeEnabled) {
      timer!.cancel();
    }
  }

  requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
    } else if (status.isDenied) {
      requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
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
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 16,
        ),
      ),
    );
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
}
