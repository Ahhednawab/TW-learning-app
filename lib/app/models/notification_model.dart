import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String body;
  final String fcmToken;
  final int notificationIndex;
  final DateTime sentAt;
  final String status;
  final String title;
  final String type;

  NotificationModel({
    required this.body,
    required this.fcmToken,
    required this.notificationIndex,
    required this.sentAt,
    required this.status,
    required this.title,
    required this.type,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      body: map['body'] ?? '',
      fcmToken: map['fcmToken'] ?? '',
      notificationIndex: map['notificationIndex'] ?? 0,
      sentAt: DateTime.parse(map['sentAt'] ?? DateTime.now().toIso8601String()),
      status: map['status'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? '',
    );
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationModel.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'fcmToken': fcmToken,
      'notificationIndex': notificationIndex,
      'sentAt': sentAt.toIso8601String(),
      'status': status,
      'title': title,
      'type': type,
    };
  }

  // Helper method to get notification icon based on type
  String get iconPath {
    switch (type) {
      case 'daily_reminder':
        return 'assets/images/reminder.png';
      case 'achievement':
        return 'assets/images/achievement.png';
      case 'streak':
        return 'assets/images/streak.png';
      case 'lesson_complete':
        return 'assets/images/lesson.png';
      default:
        return 'assets/images/notification.png';
    }
  }

  // Helper method to get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(sentAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Helper method to check if notification is read
  bool get isRead => status == 'read';

  // Helper method to check if notification is recent (within 24 hours)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(sentAt);
    return difference.inHours < 24;
  }
}
