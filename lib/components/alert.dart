
import 'package:get/get.dart';

class Alert {
  customAlert(String title, String middelText, String textCancel, String textConfrim, Function) {
    return Get.defaultDialog(
                  title: 'Log Out',
                  middleText: 'Do You Want To Log Out This Account',
                  textCancel: 'No',
                  textConfirm: 'Yes',
                  onConfirm: () async {
                    
                  });
  }
}