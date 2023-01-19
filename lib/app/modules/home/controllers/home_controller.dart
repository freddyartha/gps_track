import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gps_track/app/routes/app_pages.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  late Position position;
  Timer? timer;

  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;
  late StreamSubscription positionStream;

  @override
  void onInit() {
    _determinePosition();
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    // timer!.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('state : $state');
    switch (state) {
      case AppLifecycleState.resumed:
        updateLocation();
        break;
      case AppLifecycleState.inactive:
        updateLocation();
        break;
      case AppLifecycleState.paused:
        updateLocation();
        break;
      case AppLifecycleState.detached:
        updateLocation();
        break;
    }
  }

  lihatMap() {
    Get.toNamed(Routes.MAP_SETUP);
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
    log("update : $lat , $long");
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

  stopLocation() {
    positionStream.cancel();
  }
}
