import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NotificationController {
  static Future<String> sendPushNotification(
      {@required String title, @required String body, File image}) async {
    try {
      const String FIREBASE_SERVER_KEY =
          'AAAAAI_faLs:APA91bEnwYWJE4si9K2f6R93GOPbZ7vNHp6bAdErEZC8AHpCEO_WgqmZqbu5usOEWNrgyhKbP9RCTUIDniHij_677iuE4yg_wQep3P_QlkQZKYt6bo-zAyNB2NarKbII-i7N1_g24pOD';
      Dio dio = Dio();

      dio.options.headers["Content-Type"] = "application/json";
      dio.options.headers["Authorization"] = "key=$FIREBASE_SERVER_KEY";

      var data = {
        "notification": {
          "title": title,
          "body": body,
          // "image":
          //     "https://firebasestorage.googleapis.com/v0/b/jabardasth.appspot.com/o/jabardasth_offers_images%2Fanniversary_offer.jpg?alt=media&token=635e9fb4-8f15-415f-9212-cf9ddb04d510"
        },
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
}
