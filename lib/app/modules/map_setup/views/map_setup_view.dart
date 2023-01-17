import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/map_setup_controller.dart';

class MapSetupView extends GetView<MapSetupController> {
  const MapSetupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Trakcer'),
        centerTitle: true,
      ),
      body: Obx((() => GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: controller.sourceLocation.value, zoom: 14.5),
              markers: {
                Marker(
                    markerId: const MarkerId("start"),
                    position: controller.sourceLocation.value)
              },
            )),
      ),

      // GoogleMap(
      //   initialCameraPosition:
      //       CameraPosition(target: controller.sourceLocation.value, zoom: 14.5),
      //   markers: {
      //     Marker(
      //       markerId: const MarkerId("start"),
      //       position: controller.sourceLocation.value
      //     )
      //   },
      // ),
    );
  }
}
