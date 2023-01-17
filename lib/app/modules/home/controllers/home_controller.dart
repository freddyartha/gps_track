import 'package:get/get.dart';
import 'package:gps_track/app/routes/app_pages.dart';

class HomeController extends GetxController {

  lihatMap(){
    Get.toNamed(Routes.MAP_SETUP);
  }

}
