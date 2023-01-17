import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gps_track/app/modules/map_setup/controllers/map_setup_controller.dart';
import 'package:workmanager/workmanager.dart';

import 'app/routes/app_pages.dart';

void main() {  
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  runApp(
    GetMaterialApp(
      title: "GPS Tracker",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
  Workmanager().initialize(
      locationHandler, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    );
    Workmanager().registerPeriodicTask("task-identifier", "simpleTask", frequency: const Duration(seconds: 5));
}

void locationHandler()  {
  Workmanager().executeTask((task, inputData) {
    try { 
      MapSetupController().updateLocation();
    } catch(err) {
      print(err.toString()); // Logger flutter package, prints error on the debug console
      throw Exception(err);
    }
    return Future.value(true);
  });
}



  // StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
  //         locationSettings:
  //             const LocationSettings(accuracy: LocationAccuracy.best))
  //     .listen((Position? position) {
  //   print(position == null
  //       ? 'Unknown'
  //       : '${position.latitude.toString()}, ${position.longitude.toString()}');
  //   // Store geolocation data
  // });

