import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants/keys.dart';

class PaymentController extends GetxController {
  double amount = 20;
  Map<String, dynamic>? intentPaymentData;

  Future<void> showPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        intentPaymentData = null;
        Get.back();
        Get.snackbar(
          'Success',
          'Payment completed successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      }).onError((errorMsg, sTrace) {
        if (kDebugMode) {
          print(errorMsg.toString() + sTrace.toString());
        }
      });
    } on StripeException catch (error) {
      if (kDebugMode) print("StripeException: $error");
      Get.dialog(const AlertDialog(content: Text('Payment Cancelled')));
    } catch (errorMsg) {
      if (kDebugMode) print(errorMsg.toString());
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  Future<Map<String, dynamic>?> makeIntentForPayment(String amountToBeCharge, String currency) async {
    try {
      Map<String, dynamic> paymentInfo = {
        'amount': (int.parse(amountToBeCharge) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: paymentInfo,
        headers: {
          "Authorization": "Bearer $secretKey",
          "content-type": "application/x-www-form-urlencoded"
        },
      );

      if (kDebugMode) print("response from stripe api= ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return null;
    }
  }

  Future<void> paymentSheetInitialization(String amountToBeCharge, String currency) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      intentPaymentData = await makeIntentForPayment(amountToBeCharge, currency);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: intentPaymentData!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Namr Developer',
        ),
      );
      showPaymentSheet();
    } catch (e, s) {
      Get.back();
      if (kDebugMode) print("Init error: $e\n$s");
    }
  }
}
