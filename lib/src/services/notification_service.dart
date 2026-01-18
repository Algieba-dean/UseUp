import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/item.dart';

class NotificationService {
  // 单例模式
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 1. 初始化
  Future<void> init() async {
    // 初始化时区数据
    tz.initializeTimeZones();

    // Android 设置 (使用默认的应用图标)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 设置 (请求权限)
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
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
  Future<void> scheduleExpiryNotification(Item item) async {
    // 如果没有过期日期，或者已经消耗，就不提醒
    if (item.expiryDate == null || item.isConsumed) return;

    final now = DateTime.now();
    final expiryDate = item.expiryDate!;

    // 设定提醒时间：过期当天的早上 8:00
    // 注意：month 和 day 必须对
    var scheduledDate = DateTime(
      expiryDate.year,
      expiryDate.month,
      expiryDate.day,
      8, // 早上 8 点
      0,
    );
    /*
    // --- 🟢 测试逻辑 (新增) ---
    // 设定为：当前时间 + 10秒 (或者 1分钟)
    // 这样你添加完物品，喝口水就能收到通知
    var scheduledDate = DateTime.now().add(const Duration(seconds: 10));
    */

    // 如果 "过期当天的早上8点" 已经过去了 (比如现在是过期当天的中午)，
    // 那就不要提醒了，或者立即提醒。这里我们选择不提醒。
    if (scheduledDate.isBefore(now)) {
      return;
    }

    // 转换成 tz.TZDateTime
    final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    // 发送通知
    // 使用 item.id 作为通知的 ID，这样以后可以通过 ID 取消它
    await flutterLocalNotificationsPlugin.zonedSchedule(
      item.id,
      'UseUp Alert ⚠️', // 标题
      '${item.name} is expiring today! Use it up!', // 内容
      tzScheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'expiry_channel', // id
          'Expiry Notifications', // name
          channelDescription: 'Notifications for expiring items',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // 改为非精确模式，避免 Android 12+ 崩溃
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // 4. 取消通知
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
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
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        
    await flutterLocalNotificationsPlugin.show(
      999,
      'UseUp Test',
      'Notifications are working correctly! 🎉',
      platformChannelSpecifics,
    );
  }
}
