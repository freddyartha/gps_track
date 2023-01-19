import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 80,
              margin: const EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    controller.lihatMap();
                  },
                  child: const Text("Lihat Map")),
            ),
            // ElevatedButton(
            //   child: Text("Start the Flutter background service"),
            //   onPressed: () {
            //     Workmanager().initialize(
            //       callbackDispatcher,
            //       isInDebugMode: true,
            //     );
            //   },
            // ),
            // ElevatedButton(
            //     child: Text("Register Periodic Task (Android)"),
            //     onPressed: Platform.isAndroid
            //         ? () {
            //             Workmanager().registerPeriodicTask(
            //               simplePeriodicTask,
            //               simplePeriodicTask,
            //               initialDelay: Duration(seconds: 10),
            //             );
            //           }
            //         : null),
            // ElevatedButton(
            //   child: Text("Cancel All"),
            //   onPressed: () async {
            //     await Workmanager().cancelAll();
            //     print('Cancel all tasks completed');
            //   },
            // ),
            ElevatedButton(
              child: const Text("Stream Location"),
              onPressed: () {
                controller.listenLocation();
              },
            ),

            ElevatedButton(
              child: const Text("Stop Location"),
              onPressed: () {
                controller.stopListening();
              },
            ),
          ],
        ),
      ),
    );
  }
}
