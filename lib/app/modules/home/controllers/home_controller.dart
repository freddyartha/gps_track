import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gps_track/app/routes/app_pages.dart';
import 'package:workmanager/workmanager.dart';

const simpleTaskKey = "be.tramckrijte.workmanagerExample.simpleTask";
const simplePeriodicTask = "simplePeriodic";

const fetchBackground = "fetchBackground";

void callbackDispatcher() {
  print("===========================");
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:

        // Code to run in background
        break;
      case simplePeriodicTask:
        // HomeController().postData();
        print("===========================");
        // Code to run in background
        break;
    }
    return Future.value(true);
  });
}

class HomeController extends GetxController {
  late Position position;

  @override
  void onInit() {
    _determinePosition();

    super.onInit();
  }

  lihatMap() {
    Get.toNamed(Routes.MAP_SETUP);
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

  postData() async {
    final postData = FirebaseFirestore.instance
        .collection('live_location')
        .doc('freddy_location');
    final jsonData = {
      'latlong': [position.latitude, position.longitude],
    };
    await postData
        .update(jsonData)
        .then((value) => print("upadate latlong berhasil!"))
        .catchError((error) => print("update location : $error"));
  }

  void callbackDispatcher() {
    print("==================================");
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case simplePeriodicTask:
          postData();
          break;
      }

      return Future.value(true);
    });
  }
}
