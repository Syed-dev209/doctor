import 'dart:async';
import 'dart:convert';

  import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart'as http;

class PushNotifications{
  FirebaseMessaging fcm= FirebaseMessaging();

  void initialize(){
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
       // _navigateToItemDetail(message);
      },
    );

  }
  final String serverToken = 'AAAAuwpXEm0:APA91bFPtR2VbY9eBJbw66r_xe1ATMIbRzo8VysQ-8LAKIHbHh2kb1m5X6xLU17AdDTCFdhwHDn33K5zljeyzuZZFMVzAKti-0ClMlyx8cD_u8tXcg3R7lDRJEfxIEa2HBEQvr9PSfVN';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': 'cO6UNA3cTeSl0xVpCZQhY_:APA91bHkHrkMAc8I-s-QxFKFEqyAU2kYb4K6hgE-hLs6pw8qK7vfxV22akRP5yZ3LPdvMT_9QsWZVxJltqSGdtJobxmsA2a5_FJBb_EtjaLoehC3kb9SiZgb4NDHYNBPQAqEbu_xBON6',
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();
   firebaseMessaging.configure(
     onMessage: (Map<String, dynamic> message) async {
       completer.complete(message);
     },
   );

   return completer.future;
  }

}