import 'package:app/configs/route_path.dart';
import 'package:app/configs/text_app.dart';
import 'package:app/modules/candidate/data/models/profile_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_profile.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/pdf/item_profile_widget.dart';
import 'package:app/shared/utils/notiface_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListProfileScreen extends StatefulWidget {
  const ListProfileScreen({super.key});

  @override
  State<ListProfileScreen> createState() => _ListProfileScreenState();
}

class _ListProfileScreenState extends State<ListProfileScreen> {
  List<Profile> listProfile = [];
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    listProfile = await Modular.get<ProviderProfile>().getListProfile();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProviderProfile>();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobCV'),
        leading: IconButton(
            onPressed: () {
              Modular.to.pushNamed(RoutePath.welcomeCreateCV);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: !provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: size.height,
              width: size.width,
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: 140,
                    width: size.width,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CV',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 17),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(TextApp.youWantHave),
                        Text(TextApp.letisCreateCvNow)
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    height: listProfile.length * (450 + 15) + 70,
                    width: size.width,
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listProfile.length,
                      itemBuilder: (context, index) {
                        return ItemProfileWidget(
                          name: listProfile[index].name,
                          id: listProfile[index].id,
                          pathCV: listProfile[index].pathCv,
                          reLoadList: () async {
                            listProfile = await provider.getListProfile();
                          },
                          updateAt: listProfile[index].updatedAt,
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          listProfile.length >= 5
              ? notifaceError(context, 'Số lượng CV không vượt quá 5.')
              : Modular.to.pushNamed(RoutePath.fillFirstInfoCV);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
