import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/models/notification_model.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Notifications", 
                style: TextStyle(
                  color: blackColor, 
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                )
              ),
              Obx(() {
                if (controller.unreadCount > 0) {
                  return Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${controller.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          backgroundColor: secondaryColor,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: blackColor),
          ),
          actions: [
            Obx(() {
              if (controller.notifications.isNotEmpty) {
                return IconButton(
                  onPressed: controller.refreshNotifications,
                  icon: Icon(Icons.refresh, color: blackColor),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }
        
        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 100, color: Colors.red[300]),
                const SizedBox(height: 20),
                Text(
                  "Failed to load notifications",
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.refreshNotifications,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }
        
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 100, color: Colors.grey[400]),
                const SizedBox(height: 20),
                Text(
                  "No Notifications",
                  style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                Text(
                  "You're all caught up!",
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          child: _buildNotificationsList(),
        );
      }),
    );
  }
  
  Widget _buildNotificationsList() {
    final groupedNotifications = controller.groupedNotifications;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: groupedNotifications.keys.length,
      itemBuilder: (context, index) {
        String dateKey = groupedNotifications.keys.elementAt(index);
        List<NotificationModel> dayNotifications = groupedNotifications[dateKey]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 24),
            _buildDateHeader(dateKey),
            const SizedBox(height: 12),
            ...dayNotifications.map((notification) => 
              _buildNotificationTile(notification)
            ).toList(),
          ],
        );
      },
    );
  }
  
  Widget _buildDateHeader(String dateKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        dateKey,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }
  
  Widget _buildNotificationTile(NotificationModel notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key('${notification.fcmToken}_${notification.notificationIndex}'),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red[400],
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Icon(Icons.delete, color: Colors.white, size: 24),
        ),
        onDismissed: (direction) {
          controller.notifications.remove(notification);
        },
        child: GestureDetector(
          onTap: () => controller.markAsRead(notification),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notification.isRead ? Colors.white : primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: notification.isRead ? Colors.grey[200]! : primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(notification),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                                color: blackColor,
                              ),
                            ),
                          ),
                          Text(
                            notification.timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                      ),
                      if (notification.type != 'general') ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getTypeColor(notification.type).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getTypeDisplayName(notification.type),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getTypeColor(notification.type),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4, left: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNotificationIcon(NotificationModel notification) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getTypeColor(notification.type).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getTypeIcon(notification.type),
        color: _getTypeColor(notification.type),
        size: 20,
      ),
    );
  }
  
  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'daily_reminder':
        return Icons.schedule;
      case 'achievement':
        return Icons.emoji_events;
      case 'streak':
        return Icons.local_fire_department;
      case 'lesson_complete':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }
  
  Color _getTypeColor(String type) {
    switch (type) {
      case 'daily_reminder':
        return Colors.blue;
      case 'achievement':
        return Colors.amber;
      case 'streak':
        return Colors.orange;
      case 'lesson_complete':
        return Colors.green;
      default:
        return primaryColor;
    }
  }
  
  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'daily_reminder':
        return 'Daily Reminder';
      case 'achievement':
        return 'Achievement';
      case 'streak':
        return 'Streak';
      case 'lesson_complete':
        return 'Lesson Complete';
      default:
        return 'Notification';
    }
  }
}
