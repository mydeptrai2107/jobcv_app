// ignore_for_file: deprecated_member_use

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/chat/screens/home_chat_candidate_screen.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/welcome_create_cv.dart';
import 'package:app/modules/candidate/presentations/views/home/home_screen.dart';
import 'package:app/modules/candidate/presentations/views/profile/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JobCVHomeScreen extends StatefulWidget {
  const JobCVHomeScreen({super.key});

  @override
  State<JobCVHomeScreen> createState() => _JobCVHomeScreenState();
}

class _JobCVHomeScreenState extends State<JobCVHomeScreen> {
  int _currentIndex = 0;
  String avatar = '';

  UserModel user = Modular.get<ProviderAuth>().user;

  @override
  void initState() {
    avatar = getAvatarUser(user.avatar.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ProviderAuth>();
    final tabs = [
      const HomeScreen(),
      const WelcomeCreateCV(),
      HomeChatCandidateScreen(currentUserId: user.userId),
      const AccountScreen()
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12,
        selectedItemColor: primaryColor,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImageFactory.home,
              width: 25,
              height: 25,
              color: _currentIndex == 0 ? primaryColor : Colors.grey,
            ),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImageFactory.reader,
              width: 25,
              height: 25,
              color: _currentIndex == 1 ? primaryColor : Colors.grey,
            ),
            label: 'CV & Profile',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImageFactory.chatOutline,
              width: 25,
              height: 25,
              color: _currentIndex == 2 ? primaryColor : Colors.grey,
            ),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImageFactory.person,
              width: 25,
              height: 25,
              color: _currentIndex == 3 ? primaryColor : Colors.grey,
            ),
            label: 'Tin nhắn',
          ),
        ],
        onTap: (value) async {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
