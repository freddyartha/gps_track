import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class QrCodeController extends GetxController {
  final String dataString = "Test QR Code Generator Flutter";
  RxBool ssDisplay = false.obs;
  ScreenshotController screenshotController = ScreenshotController();


  Future<File> takeScreenshot() async {
    dynamic data;
    await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((image) async {
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = File('${directory.path}/qr.png');
        data = imagePath.writeAsBytes(image);
      }
    });
    return data;
  }

  void saveCode() async {
    ssDisplay.value = true;
    if (ssDisplay.value == true) {
      takeScreenshot().then((value) async {
        var saveImage = await GallerySaver.saveImage(value.path);
        if (saveImage == true) {
          print("Simpan QR Code berhasil!");
          ssDisplay.value = false;
        }
      }).catchError((onError) {
        print("terjadi kesalahan : $onError");
      });
    }
  }
}
