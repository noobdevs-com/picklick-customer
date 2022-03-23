import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPaymentGateway extends GetxController {
  Razorpay _razorpay = Razorpay();

  @override
  void onInit() {
    super.onInit();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.snackbar(response.orderId!, response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Fail', response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar(response.walletName!, response.walletName!);
  }

  void proceedPayment(String amount, String name, String phoneNumber) {
    var options = {
      'key': 'rzp_test_hTnKQIS9EX4E1A',
      'amount': amount,
      'name': name,
      'description': 'PickLick Food Delivery Service',
      'prefill': {'contact': phoneNumber, 'email': 'test@razorpay.com'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }
}
