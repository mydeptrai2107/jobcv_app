import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() {
    return instance;
  }
  NotificationService._internal();

  Future<void> init() async {
    
  }

  Future<void> requestIOSPermission() async {
    
  }

  Future<void> onSelecNotification(String? payload) async {}

  Future<void> showNotification(int id, String title, String body) async {
    
  }

  Future<void> scheduleNotification(
      int id, String title, String body, tz.TZDateTime tzDateTime) async {
    
  }

  Future<void> cancelNotification(int id) async {
  }

  Future<void> cancelAllNotification() async {
  }
}
