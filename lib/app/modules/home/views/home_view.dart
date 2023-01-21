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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    controller.lihatMap();
                  },
                  child: const Text("Lihat Map")),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                child: const Text("Stream Location"),
                onPressed: () {
                  controller.listenLocation();
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                child: const Text("Stop Location"),
                onPressed: () {
                  controller.stopListening();
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    controller.goToQrCodeScanner();
                  },
                  child: const Text("QR Code Scanner")),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    controller.goToQrCodeGenerator();
                  },
                  child: const Text("QR Code Generator")),
            ),
          ],
        ),
      ),
    );
  }
}
