import 'package:flutter_test/flutter_test.dart';
import 'package:use_up/src/services/notification_service.dart';
import 'package:use_up/src/models/item.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// Fake implementation
class FakeFlutterLocalNotificationsPlugin extends Fake
    implements FlutterLocalNotificationsPlugin {
  final List<int> cancelledIds = [];
  final List<PendingNotificationRequest> scheduledNotifications = [];

  @override
  Future<void> cancel(int id, {String? tag}) async {
    cancelledIds.add(id);
  }

  @override
  Future<void> zonedSchedule(
    int id,
    String? title,
    String? body,
    tz.TZDateTime scheduledDate,
    NotificationDetails? notificationDetails, {
    required UILocalNotificationDateInterpretation
        uiLocalNotificationDateInterpretation,
    AndroidScheduleMode? androidScheduleMode,
    bool androidAllowWhileIdle = false,
    DateTimeComponents? matchDateTimeComponents,
    String? payload,
  }) async {
    scheduledNotifications.add(PendingNotificationRequest(
        id, title, body, payload));
  }
  
  @override
  Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
    return scheduledNotifications;
  }
}

void main() {
  group('NotificationService', () {
    late NotificationService service;
    late FakeFlutterLocalNotificationsPlugin fakePlugin;

    setUp(() {
      service = NotificationService();
      fakePlugin = FakeFlutterLocalNotificationsPlugin();
      service.flutterLocalNotificationsPlugin = fakePlugin;
      
      // Initialize timezone for tests with real data
      tz.initializeTimeZones();
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (e) {
        // Fallback for some environments
      }
    });

    test('scheduleNotifications should schedule correct number of notifications', () async {
      final now = DateTime.now();
      final expiryDate = now.add(const Duration(days: 10));
      
      final item = Item(
        name: 'Test Item',
        purchaseDate: now,
        expiryDate: expiryDate,
        notifyDaysList: [1, 3], // 1 day before, 3 days before
      );
      item.id = 1;

      // Inject a dummy location if needed
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('UTC'));

      await service.scheduleNotifications(item);

      // notifyDaysList [1, 3] + implicit [0] = 0, 1, 3
      // Expected: 3 notifications
      expect(fakePlugin.scheduledNotifications.length, 3);
      
      final ids = fakePlugin.scheduledNotifications.map((e) => e.id).toList();
      expect(ids, containsAll([50, 51, 52]));
    });

    test('scheduleNotifications should skip past dates', () async {
      final now = DateTime.now();
      // Expiry was yesterday
      final expiryDate = now.subtract(const Duration(days: 1));
      
      final item = Item(
        name: 'Old Item',
        purchaseDate: now,
        expiryDate: expiryDate,
        notifyDaysList: [1],
      );
      item.id = 2;
      
       tz.initializeTimeZones();
       tz.setLocalLocation(tz.getLocation('UTC'));

      await service.scheduleNotifications(item);

      expect(fakePlugin.scheduledNotifications.isEmpty, true);
    });

    test('cancelNotificationsForItem should cancel 50 IDs', () async {
      await service.cancelNotificationsForItem(1);
      
      expect(fakePlugin.cancelledIds.length, 50);
      expect(fakePlugin.cancelledIds.first, 50);
      expect(fakePlugin.cancelledIds.last, 99);
    });
  });
}
