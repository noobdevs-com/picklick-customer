import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncher {
  openwhatsapp() async {
    var whatsapp = "+918300044575";
    var whatsappURl_android = "whatsapp://send?phone=$whatsapp&text=";
    try {
      launch(whatsappURl_android);
    } catch (e) {
      Get.snackbar('Error', 'e');
    }
  }
}
