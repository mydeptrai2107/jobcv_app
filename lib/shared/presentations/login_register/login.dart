// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/modules/candidate/data/repositories/chat_repositories.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/modules/recruiter/data/provider/recruiter_provider.dart';
import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassWord = true;
  bool isUser = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('account_type', 'user');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = context.watch<ProviderAuth>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 250.w,
              width: size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImageFactory.logo), fit: BoxFit.fill)),
            ),
            const Text(
              'Đăng nhập',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),

            const SizedBox(
              height: 8,
            ),

            //email
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: SvgPicture.asset(
                      ImageFactory.mail,
                      width: 25,
                      height: 25,
                      color: Colors.grey,
                    ),
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
            ),

            //password
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: passwordController,
                obscureText: showPassWord,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: SvgPicture.asset(
                      ImageFactory.lockClose,
                      width: 25,
                      height: 25,
                      color: Colors.grey,
                    ),
                    hintText: 'Nhập mật khẩu',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          showPassWord = !showPassWord;
                        });
                      },
                      child: Icon(
                        showPassWord
                            ? Icons.remove_red_eye_rounded
                            : Icons.remove_red_eye_outlined,
                        color: Colors.grey,
                      ),
                    )),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('account_type', 'user');
                    setState(() {
                      isUser = !isUser;
                    });
                  },
                  child: Text(
                    'Tìm việc  ',
                    style: TextStyle(
                        color: isUser ? primaryColor : Colors.grey,
                        fontWeight:
                            isUser ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('account_type', 'company');
                    setState(() {
                      isUser = !isUser;
                    });
                  },
                  child: Text(
                    '  Tuyển dụng',
                    style: TextStyle(
                        color: !isUser ? primaryColor : Colors.grey,
                        fontWeight:
                            !isUser ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            provider.isLoadingLogin
                ? const CircularProgressIndicator()
                : ButtonApp(
                    onPress: () async {
                      provider.setLoadingLogin(true);
                      try {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? type = prefs.getString('account_type');
                        await provider.login(emailController.text.trim(),
                            passwordController.text.trim());

                        if (type == 'user') {
                          if (provider.isLogged) {
                            FirebaseService firebaseService = FirebaseService();
                            UserModel userModel = await provider.getUserLogin();
                            await firebaseService.signInFunction(userModel);
                            Modular.to.navigate(RoutePath.home);
                          }
                        } else {
                          await Modular.get<RecruiterProvider>().findMe();
                          final recruiter =
                              Modular.get<RecruiterProvider>().recruiter;
                          await Modular.get<RecruitmentProvider>()
                              .getRecruitments(recruiter.id);
                          await Modular.get<RecruitmentProvider>()
                              .showListByStatus();
                          Modular.to.navigate(RoutePath.mainRecruiter);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.warning),
                              Expanded(
                                  child:
                                      Text(jsonDecode(e.toString())['message']))
                            ],
                          ),
                        ));
                      }
                    },
                    title: 'Đăng nhập',
                    width: size.width,
                  ),

            SizedBox(
              height: 20.h,
            ),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bạn chưa có tài khoản?'),
                GestureDetector(
                  onTap: () {
                    Modular.to.pushNamed(RoutePath.register);
                  },
                  child: const Text(
                    ' Đăng ký ngay',
                    style: TextStyle(color: primaryColor),
                  ),
                )
              ],
            ),

            SizedBox(
              height: 30.h,
            )
          ],
        ),
      ),
    );
  }
}
