import 'dart:convert';

import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/shared/utils/notiface_message.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChangePassWordScreen extends StatefulWidget {
  const ChangePassWordScreen({super.key});

  @override
  State<ChangePassWordScreen> createState() => _ChangePassWordScreenState();
}

class _ChangePassWordScreenState extends State<ChangePassWordScreen> {
  final _keyForm = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _newPwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  UserModel user = Modular.get<ProviderAuth>().user;

  @override
  void initState() {
    _emailController.text = user.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Đổi mật khẩu"),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        width: size.width,
        child: Form(
          key: _keyForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  'Email đăng nhập',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.withOpacity(0.3)),
                child: Center(
                  child: TextFormField(
                    enabled: false,
                    controller: _emailController,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  'Mật khẩu hiện tại',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              TextFormField(
                controller: _pwController,
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(color: Colors.grey)),
                    hintText: "Nhập mật khẩu hiện tại",
                    filled: true,
                    fillColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    floatingLabelStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 16)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mật khẩu hiện tại không được bỏ trống';
                  }
                  return null;
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  'Mật khẩu mới',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              TextFormField(
                controller: _newPwController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(color: Colors.grey)),
                    hintText: "Nhập mật khẩu mới",
                    filled: true,
                    fillColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    floatingLabelStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 16)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mật khẩu mới không được bỏ trống';
                  }
                  return null;
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  'Nhập lại mật khẩu mới',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              TextFormField(
                controller: _confirmPwController,
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(color: Colors.grey)),
                    hintText: "Nhập lại mật khẩu mới",
                    filled: true,
                    fillColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    floatingLabelStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 16)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Xác nhận mật khẩu không được bỏ trống';
                  }
                  return null;
                },
              ),
              Expanded(child: Container()),
              ButtonApp(
                title: "Thay đổi mật khẩu",
                onPress: () async {
                  if (!_keyForm.currentState!.validate()) return;
                  try {
                    await Modular.get<ProviderAuth>().changePw(
                        Modular.get<ProviderAuth>().accountType,
                        _emailController.text.trim(),
                        _pwController.text.trim(),
                        _newPwController.text.trim(),
                        _confirmPwController.text.trim());
                    ElegantNotification.success(
                      width: 360,
                      animation: AnimationType.fromTop,
                      title: const Text('Thay đổi mật khẩu'),
                      description:
                          const Text('Thay đổi mất khẩu lưu thành công'),
                      onDismiss: () {},
                    // ignore: use_build_context_synchronously
                    ).show(context);
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    notifaceError(context, jsonDecode(e.toString())['message']);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
