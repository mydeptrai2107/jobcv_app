import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/recruiter/data/provider/recruiter_provider.dart';
import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLogined = false;
  String type = '';

  initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogined = prefs.getString('refreshToken') != null;
    type = prefs.getString('account_type') ?? '';
    await Future.delayed(const Duration(seconds: 2), () async {
      if (isLogined) {
        if (type == 'user') {
          await Modular.get<ProviderAuth>().getUserLogin();
          Modular.to.navigate(RoutePath.home);
        } else {
          await Modular.get<RecruiterProvider>().findMe();
          final recruiter = Modular.get<RecruiterProvider>().recruiter;
          await Modular.get<RecruitmentProvider>()
              .getRecruitments(recruiter.id);
          await Modular.get<RecruitmentProvider>().showListByStatus();
          Modular.to.navigate(RoutePath.mainRecruiter);
        }
      } else {
        Modular.to.navigate(RoutePath.login);
      }
    });
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    context.watch<RecruiterProvider>();
    context.watch<ProviderAuth>();

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: primaryColor,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'JobCV',
              style: TextStyle(
                fontSize: 45,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Tìm kiếm, kết nối, xây dựng thành công',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
