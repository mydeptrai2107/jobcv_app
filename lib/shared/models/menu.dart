import 'package:app/configs/image_factory.dart';

class Menu {
  String title;
  String assetsIcon;
  Menu({required this.title, required this.assetsIcon});
}

final bottomNavBarRecruiter = [
  Menu(title: 'Trang chủ', assetsIcon: ImageFactory.home),
  Menu(title: 'Tin tuyển dụng', assetsIcon: ImageFactory.documentText),
  Menu(title: 'Tin Nhắn', assetsIcon: ImageFactory.chatOutline),
  Menu(title: 'Quản lý CV', assetsIcon: ImageFactory.person),
];
