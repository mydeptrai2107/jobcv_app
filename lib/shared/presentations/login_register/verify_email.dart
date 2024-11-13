import 'dart:async';

import 'package:app/configs/route_path.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify email"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("A Verification email has been sent your email."),
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.email),
              label: const Text("Resent Email")),
          const SizedBox(
            height: 8,
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50)),
            child: const Text(
              "Cancel",
              style: TextStyle(fontSize: 24),
            ),
          )
        ],
      ),
    );
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      // ignore: use_build_context_synchronously
      ElegantNotification.success(
        width: 360,
        animation: AnimationType.fromTop,
        title: const Text('Đăng ký'),
        description: const Text('Đăng ký thành công. Đăng nhập ngay.'),
        onDismiss: () {},
      ).show(context);
      await Future.delayed(
        const Duration(milliseconds: 3000),
        () => Modular.to.pushNamed(RoutePath.login),
      );
      Modular.to.navigate(RoutePath.login);
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });

      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {}
  }
}
