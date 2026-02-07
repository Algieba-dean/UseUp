import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../models/item.dart';

class NotificationService {
  // 单例模式
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 1. 初始化
  Future<void> init() async {
    // 初始化时区数据
    tz.initializeTimeZones();
    
    // 获取并设置本地时区
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Android 设置 (使用默认的应用图标)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 设置 (请求权限)
        const DarwinInitializationSettings initializationSettingsDarwin =
            DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
        );
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // 2. 请求权限 (Android 13+ 需要手动请求)
  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // 3. 安排通知
  Future<void> scheduleNotifications(Item item) async {
    // 先取消旧的通知，防止重复或残留
    await cancelNotificationsForItem(item.id);

    // 如果没有过期日期，或者已经消耗，就不提醒
    if (item.expiryDate == null || item.isConsumed) return;

    final expiryDate = item.expiryDate!;
    // 确保列表包含 "0" (到期当天)，如果用户没有显式添加的话 (可选策略，这里假设 notifyDaysList 是用户期望的全部提醒)
    // 但通常用户肯定希望过期当天有提醒。
    // 我们合并用户的设置和 "0" (当天)，去重并排序
    final Set<int> daysToNotify = Set.from(item.notifyDaysList);
    daysToNotify.add(0); // 强制包含当天提醒

    // 转换为排序列表
    final sortedDays = daysToNotify.toList()..sort();

    // 遍历每一个提醒天数
    // 我们使用 itemId * 50 + index 作为 notification ID
    // 限制：每个物品最多支持 50 个提醒点 (足够了)
    for (int i = 0; i < sortedDays.length; i++) {
      if (i >= 50) break; // 安全限制

      final daysBefore = sortedDays[i];
      final scheduledDate = DateTime(
        expiryDate.year,
        expiryDate.month,
        expiryDate.day,
        8, // 早上 8 点
        0,
      ).subtract(Duration(days: daysBefore));

      // 如果提醒时间已经过去了，就不提醒了
      if (scheduledDate.isBefore(DateTime.now())) {
        continue;
      }

      final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );

      final notificationId = _generateNotificationId(item.id, i);
      final String bodyText = daysBefore == 0 
          ? '${item.name} is expiring today! Use it up!'
          : (daysBefore == 1 
              ? '${item.name} is expiring tomorrow!' 
              : '${item.name} is expiring in $daysBefore days!');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'UseUp Alert ⚠️',
        bodyText,
        tzScheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'expiry_channel',
            'Expiry Notifications',
            channelDescription: 'Notifications for expiring items',
            importance: Importance.max,
            priority: Priority.high,
            groupKey: 'com.useup.expiry_group', // 添加分组 Key
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            threadIdentifier: 'com.useup.expiry_group', // iOS 分组
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  // 4. 取消指定物品的所有通知
  Future<void> cancelNotificationsForItem(int itemId) async {
    // 这里的假设是每个物品最多有 50 个提醒 (index 0-49)
    // 我们遍历这个范围尝试取消
    for (int i = 0; i < 50; i++) {
      final id = _generateNotificationId(itemId, i);
      await flutterLocalNotificationsPlugin.cancel(id);
    }
  }
  
  // 保留旧的单 ID 取消方法 (如果有其他地方用到)，或者直接标记为废弃
  Future<void> cancelNotification(int id) async {
     await flutterLocalNotificationsPlugin.cancel(id);
  }

  int _generateNotificationId(int itemId, int index) {
    return itemId * 50 + index;
  }

  // 5. Test Notification
  Future<void> showInstantNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Channel for testing notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
        
    await flutterLocalNotificationsPlugin.show(
      999,
      'UseUp Test',
      'Notifications are working correctly! 🎉',
      platformChannelSpecifics,
    );
  }

  // 6. Delayed Test Notification (10 seconds)
  Future<void> showDelayedNotification() async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      998,
      'UseUp Delayed Test',
      'This notification was sent 10 seconds ago! ⏳',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // 7. Debug: Show Grouped Notifications (Simulate 3 items expiring today)
  Future<void> debugShowGroupedNotifications() async {
    const androidDetails = AndroidNotificationDetails(
      'expiry_channel',
      'Expiry Notifications',
      importance: Importance.max,
      priority: Priority.high,
      groupKey: 'com.useup.expiry_group',
    );
    const iosDetails = DarwinNotificationDetails(
      threadIdentifier: 'com.useup.expiry_group',
    );
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Send 3 notifications rapidly
    await flutterLocalNotificationsPlugin.show(
      1001, 'UseUp Alert', '🍎 Apple is expiring today!', details);
    await flutterLocalNotificationsPlugin.show(
      1002, 'UseUp Alert', '🥛 Milk is expiring today!', details);
    await flutterLocalNotificationsPlugin.show(
      1003, 'UseUp Alert', '🍞 Bread is expiring today!', details);
  }

  // 8. Debug: Check Pending Notifications
  Future<void> debugCheckPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    
    print('--- Pending Notifications: ${pendingNotificationRequests.length} ---');
    for (var notification in pendingNotificationRequests) {
      print('ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}, Payload: ${notification.payload}');
    }
    print('-------------------------------------------');
  }
}
