import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scan_products/firestore_service.dart';
import 'package:scan_products/url_checker/controller.dart';
import 'package:scan_products/widgets/custom_button.dart';
import 'package:scan_products/widgets/custom_textfield.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';

// import 'package:screenshot/screenshot.dart';

class UrlCheckerPage extends StatefulWidget {
  const UrlCheckerPage({super.key});

  @override
  State<UrlCheckerPage> createState() => _UrlCheckerPageState();
}

class _UrlCheckerPageState extends State<UrlCheckerPage> {
  // ScreenshotController screenshotController = ScreenshotController();
  final _controller = Get.put(HomepageController());
  String _data = 'EdBguAUrOH0xXkdTi7aEKGUA5JlTLY';
  bool loading = false;

  void generateRandomText() {
    const String characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String randomText = '';

    for (int i = 0; i < 30; i++) {
      int randomIndex = random.nextInt(characters.length);
      randomText += characters[randomIndex];
    }

    setState(() {
      _data = randomText;
      print(randomText);
    });
  }

  Future<void> generateQR(BuildContext context) async {
    generateRandomText();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 200,
            height: 200,
            child: QrImageView(
              data: _data,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
        );
      },
    );
  }

  Future<void> saveQrCodeImage() async {
    try {
      // Generate the QR code as an image
      final image = await QrPainter(
        data: _data,
        version: QrVersions.auto,
        // size: 200.0,
      ).toImage(200);

      // Convert the image to Uint8List
      final ByteData? byteData =
          await image.toByteData(format: ImageByteFormat.png);
      final Uint8List uint8List = byteData!.buffer.asUint8List();

      // Save the image to the gallery
      await ImageGallerySaver.saveImage(uint8List);
    } catch (e) {
      print('Error saving QR code image: $e');
    }
  }

  Future<void> registerProduct() async {
    try {
      setState(() {
        loading = true;
      });
      String qrCodeData = _data;

      await FirestoreService().addProduct(
        _controller.productName.text,
        _controller.productID.text,
        _controller.price.text,
        _controller.discount.text,
        qrCodeData,
      );

      setState(() {
        loading = false;
        _controller.productName.text = "";
        _controller.productID.text = "";
        _controller.price.text = "";
        _controller.discount.text = "0";
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Successfully Uploaded"),
        backgroundColor: Colors.teal, // Adjusted color scheme
      ));
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
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
                        Text(
                          "Create a New Product",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w700,
                            height: 1.8,
                            wordSpacing: 1.5,
                          ),
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
                          "",
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
                        CustomButton(
                          width: 300,
                          height: 45,
                          child: Text(
                            "Generate QR Code",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              height: 1.8,
                              wordSpacing: 1.5,
                            ),
                          ),
                          onPressed: () {
                            generateQR(context);
                            registerProduct();
                            // _captureAndSharePng();
                          },
                        ),
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
