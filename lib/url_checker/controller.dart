// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomepageController extends GetxController {
  static HomepageController get to => Get.find();

  TextEditingController productName = TextEditingController();
  TextEditingController productID = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController discount = TextEditingController();

  bool loading = false;
}
