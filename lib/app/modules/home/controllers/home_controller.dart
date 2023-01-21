import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gps_track/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class HomeController extends GetxController {
  Timer? timer;

  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;
  late StreamSubscription positionStream;

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void onInit() {
    // WidgetsBinding.instance.addObserver(this);
    requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    enableBackgroundMode();
    super.onInit();
  }

  lihatMap() {
    Get.toNamed(Routes.MAP_SETUP);
  }

  goToQrCodeGenerator(){
    Get.toNamed(Routes.QR_CODE);
  }

  goToQrCodeScanner(){
    Get.toNamed(Routes.DASHBOARD);
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

  stopLocation() {
    positionStream.cancel();
  }

  Future<void> listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print("terjadi kesalahan : $onError");
      _locationSubscription?.cancel();
      _locationSubscription = null;
    }).listen((loc.LocationData currentlocation) async {
      lat.value = currentlocation.latitude!;
      long.value = currentlocation.longitude!;
      postData();
    });
  }

  stopListening() {
    _locationSubscription?.cancel();

    _locationSubscription = null;
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

  Future<bool> enableBackgroundMode() async {
    bool bgModeEnabled = await location.isBackgroundModeEnabled();
    if (bgModeEnabled) {
      return true;
    } else {
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      try {
        bgModeEnabled = await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      // print(_bgModeEnabled); //True!
      return bgModeEnabled;
    }
  }
}
