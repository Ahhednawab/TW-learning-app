import 'package:get/get.dart';
import 'package:mandarinapp/app/services/firebase_service.dart';
import 'package:mandarinapp/app/models/notification_model.dart';

class NotificationsController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
 
  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  Future<void> getNotifications() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      // Get notifications from firestore
      List<NotificationModel> fetchedNotifications = await FirebaseService.getNotifications();
      
      // Sort notifications by sentAt date (newest first)
      fetchedNotifications.sort((a, b) => b.sentAt.compareTo(a.sentAt));
      
      notifications.value = fetchedNotifications;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load notifications: $e';
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNotifications() async {
    await getNotifications();
  }

  Future<void> markAsRead(NotificationModel notification) async {
    try {
      // Update notification status to read in Firebase
      await FirebaseService.markNotificationAsRead(notification.fcmToken, notification.notificationIndex);
      
      // Update local notification list
      int index = notifications.indexWhere((n) => 
        n.fcmToken == notification.fcmToken && 
        n.notificationIndex == notification.notificationIndex
      );
      
      if (index != -1) {
        notifications[index] = NotificationModel(
          body: notification.body,
          fcmToken: notification.fcmToken,
          notificationIndex: notification.notificationIndex,
          sentAt: notification.sentAt,
          status: 'read',
          title: notification.title,
          type: notification.type,
        );
        notifications.refresh();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Get unread notifications count
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  // Get notifications grouped by date
  Map<String, List<NotificationModel>> get groupedNotifications {
    Map<String, List<NotificationModel>> grouped = {};
    
    for (NotificationModel notification in notifications) {
      String dateKey = _getDateKey(notification.sentAt);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notification);
    }
    
    return grouped;
  }

  String _getDateKey(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return 'Today';
    } else if (notificationDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
