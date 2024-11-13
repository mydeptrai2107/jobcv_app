// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:app/modules/candidate/data/repositories/authen_firebase_repositories.dart';
import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/shared/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showPassWord = true;
  bool showConfirmPW = true;
  AuthenFirebaseRepositories authenFirebaseRepositories =
      AuthenFirebaseRepositories();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

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
              'Đăng ký tài khoản',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),

            //person
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: SvgPicture.asset(
                      ImageFactory.person,
                      width: 25,
                      height: 25,
                      color: Colors.grey,
                    ),
                    hintText: 'Họ và tên',
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
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

            //confirm password
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: confirmPwController,
                obscureText: showConfirmPW,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: SvgPicture.asset(
                      ImageFactory.lockClose,
                      width: 25,
                      height: 25,
                      color: Colors.grey,
                    ),
                    hintText: 'Nhập lại mật khẩu',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          showConfirmPW = !showConfirmPW;
                        });
                      },
                      child: Icon(
                        showConfirmPW
                            ? Icons.remove_red_eye_rounded
                            : Icons.remove_red_eye_outlined,
                        color: Colors.grey,
                      ),
                    )),
              ),
            ),

            SizedBox(
              height: 15.h,
            ),

            provider.isLoadingRegister
                ? const CircularProgressIndicator()
                : ButtonApp(
                    onPress: () async {
                      try {
                        await provider.register(
                            emailController.text.toString().trim(),
                            passwordController.text.toString().trim(),
                            confirmPwController.text.toString().trim(),
                            Format.getFirstNameByName(
                                nameController.text.toString().trim()),
                            Format.getLastNameByName(
                                nameController.text.toString().trim()));
                        
                        await provider.signUpEmail(
                            emailController.text, passwordController.text);
                        await Modular.to.pushNamed(
                          RoutePath.verifyEmail,
                        );
                        
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.warning),
                              Expanded(child: Text(e.toString()))
                            ],
                          ),
                        ));
                      }
                    },
                    title: 'Đăng ký',
                    //width: size.width,
                  ),

            Expanded(child: Container()),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bạn đã có tài khoản?'),
                GestureDetector(
                  onTap: () {
                    Modular.to.pushNamed(RoutePath.login);
                  },
                  child: const Text(
                    ' Đăng nhập ngay',
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
