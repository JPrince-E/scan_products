import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:scan_products/url_checker/controller.dart';
import 'package:scan_products/widgets/custom_button.dart';
import 'package:scan_products/widgets/custom_textfield.dart';

class ViewProductPage extends StatefulWidget {
  const ViewProductPage({super.key});

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  final _controller = Get.put(HomepageController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String scanBarcode = 'Unknown';

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      scanBarcode = barcodeScanRes;
      fetchProductDetails(scanBarcode);
    });
  }

  Future<void> fetchProductDetails(String qrCodeData) async {
    try {
      // Replace 'products' with the actual collection name in your Firestore
      var query = await _firestore
          .collection('products')
          .where('qrCodeData', isEqualTo: qrCodeData)
          .get();

      if (query.docs.isNotEmpty) {
        var product = query.docs.first.data();
        _controller.productName.text = product['productName'];
        _controller.productID.text = product['productID'];
        _controller.price.text = product['price'].toString();
        _controller.discount.text = product['discount'].toString();
      } else {
        // Handle the case where no matching product is found
        print('Product not found!');
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }
  }

  Future<void> scanQRCode() async {
    if (scanBarcode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'required!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red, // Adjusted color scheme
        ),
      );
    } else {
      await scanQR();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "",
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      // ),
      extendBodyBehindAppBar: true,
      body: GetBuilder<HomepageController>(
        init: _controller,
        builder: (_) {
          return Container(
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/grocery.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(size.width * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * 0.02),
                color: const Color.fromARGB(255, 6, 7, 22).withOpacity(0.8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: size.width * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomButton(
                          width: 300,
                          height: 45,
                          child: const Text(
                            "Scan QR Code",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              height: 1.8,
                              wordSpacing: 1.5,
                            ),
                          ),
                          onPressed: () async {
                            if (scanBarcode.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'required!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      Colors.red, // Adjusted color scheme
                                ),
                              );
                            } else {
                              await scanQR();
                            }
                          },
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: size.width * 0.35,
                          child: Column(
                            children: [
                              Text(
                                "Product Name",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.023,
                                  fontWeight: FontWeight.w500,
                                  height: 1.8,
                                  wordSpacing: 1.3,
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              Text(
                                "Product ID",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.023,
                                  fontWeight: FontWeight.w500,
                                  height: 1.8,
                                  wordSpacing: 1.3,
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              Text(
                                "Price",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.023,
                                  fontWeight: FontWeight.w500,
                                  height: 1.8,
                                  wordSpacing: 1.3,
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              Text(
                                "Discount",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.023,
                                  fontWeight: FontWeight.w500,
                                  height: 1.8,
                                  wordSpacing: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                      color: Colors.blue.shade800.withOpacity(0.38),
                    ),
                    width: size.width * 0.50,
                    child: Column(
                      children: [
                        Text(
                          "View Product Details ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w700,
                            height: 1.8,
                            wordSpacing: 1.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: CustomTextfield(
                            textEditingController: _controller.productName,
                            hintText: "Enter the product name here",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: CustomTextfield(
                            textEditingController: _controller.productID,
                            hintText: "Enter the product ID here",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: CustomTextfield(
                            textEditingController: _controller.price,
                            hintText: "Enter the price of product here",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: CustomTextfield(
                            textEditingController: _controller.discount,
                            hintText: "0",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
