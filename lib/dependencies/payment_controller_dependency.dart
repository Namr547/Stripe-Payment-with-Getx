
import 'package:get/get.dart';

import '../controllers/payment_controller.dart';

class PaymentControllerBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(()=> PaymentController());
  }
}