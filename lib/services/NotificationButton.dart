import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List<String> notifications = [];

  void addNotification(String message) {
    notifications.add(message);
    notifyListeners();
  }

  void removeNotificationAt(int index) {
    if (index >= 0 && index < notifications.length) {
      notifications.removeAt(index);
      notifyListeners();
    }
  }
}
