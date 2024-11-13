import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

showDialogMessage({required String message}) {
  showDialog(
      context: Modular.routerDelegate.navigatorKey.currentContext!,
      builder: (_) => AlertDialog(content: Text(message)));
}
