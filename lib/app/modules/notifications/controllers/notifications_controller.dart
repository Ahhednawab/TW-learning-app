import 'package:get/get.dart';
import 'package:mandarinapp/app/services/firebase_service.dart';

class NotificationsController extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;
 
  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  Future<void> getNotifications() async {
    // get notifications from firestore
    List<Map<String, dynamic>> notifications = await FirebaseService.getNotifications();
    this.notifications.value = notifications;
  }


  String calculateDuration(String createdAt) {
    final DateTime createdTime = DateTime.parse(createdAt);
    final Duration difference = DateTime.now().difference(createdTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
