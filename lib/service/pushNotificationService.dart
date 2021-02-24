import 'dart:async';
import 'dart:convert';

  import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart'as http;

class PushNotifications{

  final String serverToken = 'AAAAuwpXEm0:APA91bFPtR2VbY9eBJbw66r_xe1ATMIbRzo8VysQ-8LAKIHbHh2kb1m5X6xLU17AdDTCFdhwHDn33K5zljeyzuZZFMVzAKti-0ClMlyx8cD_u8tXcg3R7lDRJEfxIEa2HBEQvr9PSfVN';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  void initialize(){
    firebaseMessaging.configure(
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


  Future<Map<String, dynamic>> sendAndRetrieveMessage(String userToken) async {
    print('user tokrn in method $userToken');
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
            'body': 'Get started with your exercise.',
            'title': 'New exercise is uploaded'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': userToken,
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
print('notiff completed');
   return completer.future;
  }
}