import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/candidate/data/repositories/user_repositories.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemUserChat extends StatefulWidget {
  const ItemUserChat(
      {super.key,
      required this.idUser,
      required this.idCompany,
      required this.lastMsgl});
  final String idUser;
  final String idCompany;
  final String lastMsgl;
  @override
  State<ItemUserChat> createState() => _ItemUserChatState();
}

class _ItemUserChatState extends State<ItemUserChat> {
  Company? company;

  UserRepositories userRepositories = UserRepositories();

  initData() async {
    company =
        await Modular.get<ProviderCompany>().getCompanyById(widget.idCompany);
    setState(() {});
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed(RoutePath.chatScreen, arguments: [
          widget.idUser,
          widget.idCompany,
          company!.name,
          getAvatarCompany(company!.avatar.toString())
        ]);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        width: size.width,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 0.5, color: Colors.grey.withOpacity(0.5)))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              height: 36.sp,
              width: 36.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                image: company?.avatar == ''
                    ? const DecorationImage(
                        image: AssetImage(ImageFactory.editCV),
                        fit: BoxFit.cover)
                    : DecorationImage(
                        image: NetworkImage(
                            getAvatarCompany(company?.avatar ?? '')),
                        fit: BoxFit.cover),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (company?.name ?? '...').trim(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.lastMsgl,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
