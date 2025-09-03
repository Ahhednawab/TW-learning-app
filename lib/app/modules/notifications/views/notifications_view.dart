import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/widgets/NotificationTile.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text("Notification", style: TextStyle(color: blackColor, fontSize: 20, fontWeight: FontWeight.bold)), 
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          backgroundColor: secondaryColor,
          leading: IconButton(
            onPressed: () {
            Get.back();
          }, icon: Icon(Icons.arrow_back_ios_new_rounded, color: blackColor)),
          ),
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 100, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  "No Notifications",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
          );
        } else {
          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              final String duration = controller.calculateDuration(
                notification['createdAt'],
              );
              return Dismissible(
                key: Key(notification['id'].toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: primaryColor,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(Icons.delete, color: whiteColor),
                ),
                onDismissed: (direction) {
                  final notificationId = notification['id'].toString();

                  // Immediately remove the notification from the list in the controller
                  controller.notifications.removeAt(index);

                  // Handle the dismiss notification logic asynchronously
                  // controller.dismissNotification(notificationId);
                },
                child: customNotificationTile(
                  index: notification['data']['title'],
                  subtitle: notification['data']['description'] ?? '',
                  duration: duration,
                ),
              );
            },
          );
        }
      }),
    );
  }
}
