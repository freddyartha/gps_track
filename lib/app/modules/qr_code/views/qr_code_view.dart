import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../controllers/qr_code_controller.dart';

class QrCodeView extends GetView<QrCodeController> {
  const QrCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambulance QR Code'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Screenshot(
              controller: controller.screenshotController,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => controller.ssDisplay.value == true
                          ? Column(children: const [
                              Text(
                                "Rumah Sakit Test",
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ])
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                            ),
                    ),
                    QrImage(
                      backgroundColor: Colors.white,
                      data: controller.dataString,
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * 0.8,
                      gapless: false,
                      embeddedImage: const AssetImage('assets/fd.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size(80, 80),
                      ),
                    ),
                    Obx(
                      () => controller.ssDisplay.value == true
                          ? Column(children: const [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Ambulance Nomor 0001",
                                textAlign: TextAlign.center,
                              )
                            ])
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                            ),
                    ),
                  ],
                ),
              )),
          Obx(
            () => controller.ssDisplay.value == true
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                  )
                : Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              controller.saveCode();
                            },
                            child: const Text("Save to Gallery")),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              controller.generatePdf();
                            },
                            child: const Text("Print")),
                      ),
                    ],
                  ),
          ),
        ],
      )),
    );
  }
}
