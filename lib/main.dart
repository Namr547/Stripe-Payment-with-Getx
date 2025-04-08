import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:stripe_payment_getx/dependencies/payment_controller_dependency.dart';
import 'package:stripe_payment_getx/views/home_page.dart';
import 'package:stripe_payment_getx/constants/keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //get your keys from stripe website and paste here
  Stripe.publishableKey = publishableKey;
  await Stripe.instance.applySettings();


  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Stripe with GetX',
      debugShowCheckedModeBanner: false,
      initialBinding: PaymentControllerBinding(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

