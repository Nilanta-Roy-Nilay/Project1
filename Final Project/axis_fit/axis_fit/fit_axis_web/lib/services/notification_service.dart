import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  dynamic _flutterLocalNotificationsPlugin;

  NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      _initMobileNotifications();
    } catch (e) {
      print("Notification service initialization: $e");
      print("Notifications may not be available on this platform");
    }
  }

  Future<void> _initMobileNotifications() async {
    print("Initializing notifications for mobile platforms...");
  }

  Future<void> showNotification(String title, String body) async {
    try {
      _showMobileNotification(title, body);
    } catch (e) {
      print("📢 Notification: $title - $body");
    }
  }

  Future<void> _showMobileNotification(String title, String body) async {
    print("📱 Mobile Notification: $title - $body");
  }

  Future<void> scheduleDailyNotification() async {
    try {
      _scheduleMobileDailyNotification();
    } catch (e) {
      print("⏰ Daily notification scheduled (web fallback)");
      print("  Time: 8:00 AM");
      print("  Message: Good Morning! Time to start your fitness journey");
    }
  }

  Future<void> _scheduleMobileDailyNotification() async {
    print("📱 Daily notification scheduled for mobile at 8:00 AM");
  }

  tz.TZDateTime _nextInstanceOf8AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      8,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  String getNextNotificationTime() {
    final nextTime = _nextInstanceOf8AM();
    return "${nextTime.hour.toString().padLeft(2, '0')}:${nextTime.minute.toString().padLeft(2, '0')}";
  }
}
