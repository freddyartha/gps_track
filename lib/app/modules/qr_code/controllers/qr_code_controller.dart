import 'dart:io';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

class QrCodeController extends GetxController {
  final String dataString = "ambulance/0001";
  RxBool ssDisplay = false.obs;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? gambar;

  Future<File> takeScreenshot() async {
    dynamic data;
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((image) async {
      if (image != null) {
        gambar = image;
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

  generatePdf() async {
    const title = 'QR Code';
    takeScreenshot().then(
      (value) => Printing.layoutPdf(
        onLayout: (format) => _generatePdf(format, title, gambar!),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String title, Uint8List gambar) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final image = pw.MemoryImage(gambar);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(30.0),
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text(
                  "Rumah Sakit Test",
                  textAlign: pw.TextAlign.center,
                ),
                pw.Image(image),
                pw.Text(
                  "Ambulance Nomor 0001",
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }
}
