// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'main.dart';
//
// void showNotification() async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//           channelId, 'channelName', //Channel ID
//         'channel_name',// channel name
//         'channelDescription',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker',
//       );
//   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//     iOS: IOSNotificationDetails(),
//   );
//   await flutterLocalNotificationsPlugin.show(
//     0, // Notification ID
//     'Hello', // Notification Title
//     'This is a test notification.', // Notification Body
//     platformChannelSpecifics,
//     payload: 'Default_Sound', // Payload
//   );
// }