import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class NotificationController {
  static Future<String> sendPushNotification(
      {@required String title, @required String body, File image}) async {
    try {
      const String FIREBASE_SERVER_KEY =
          'AAAAAI_faLs:APA91bEnwYWJE4si9K2f6R93GOPbZ7vNHp6bAdErEZC8AHpCEO_WgqmZqbu5usOEWNrgyhKbP9RCTUIDniHij_677iuE4yg_wQep3P_QlkQZKYt6bo-zAyNB2NarKbII-i7N1_g24pOD';
      Dio dio = Dio();

      dio.options.headers["Content-Type"] = "application/json";
      dio.options.headers["Authorization"] = "key=$FIREBASE_SERVER_KEY";
      String imageURL;
      if (image != null) {
        imageURL = await _storeImageToFirestore(image);
      }

      var data = {
        "notification": {"title": title, "body": body, "image": imageURL},
        "to": "/topics/all"
      };
      Response _response = await dio.post(
        'https://fcm.googleapis.com/fcm/send',
        data: data,
      );
      return _response.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> _storeImageToFirestore(File image) async {
    try {
      final ref = FirebaseStorage.instance.ref(
          'NotificationImages/${DateTime.now().millisecondsSinceEpoch.toString() + basename(image.path)}');

      var task = ref.putFile(image);
      if (task == null) return null;
      final snapshot = await task.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      return urlDownload;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }
}
