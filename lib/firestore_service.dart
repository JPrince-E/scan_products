import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addScan(String scanBarcode) async {
    try {
      await firestore.collection('scans').add({
        "scanBarcode": scanBarcode,
        "date": DateTime.now(),
      });
    } catch (e) {
      //
    }
  }

  Future addProduct(String productName, String productID, String price,
      String discount, String qrCodeData) async {
    try {
      await firestore.collection('products').add({
        "productName": productName,
        "productID": productID,
        "price": price,
        "discount": discount,
        "qrCodeData": qrCodeData,
        "date": DateTime.now(),
      });
    } catch (e) {
      //
    }
  }
}
