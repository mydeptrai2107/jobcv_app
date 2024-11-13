import 'dart:io';

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/models/hive_models/experience_model.dart';
import 'package:app/modules/candidate/data/models/hive_models/school_model.dart';
import 'package:app/modules/candidate/data/models/hive_models/skill_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_app.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/modules/candidate/domain/providers/provider_profile.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/pdf/widgets/information_item.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/widgets/experience_item_pdf.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/widgets/skill_item_pdf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:widgets_to_image/widgets_to_image.dart';

class PreviewCVScreen extends StatefulWidget {
  const PreviewCVScreen(
      {super.key,
      required this.name,
      required this.position,
      required this.birthday,
      required this.email,
      required this.phoneNumber,
      this.link,
      this.git,
      required this.address,
      required this.careerGoals,
      required this.experienceModel,
      required this.schoolModell,
      this.imageFile,
      required this.idCV,
      required this.nameCV,
      required this.language});

  final String name;
  final String position;
  final DateTime birthday;
  final String email;
  final String phoneNumber;
  final String? link;
  final String? git;
  final String address;
  final String careerGoals;
  final List<SchoolModel> schoolModell;
  final List<ExperienceModel> experienceModel;
  final File? imageFile;
  final String idCV;
  final String nameCV;
  final String language;

  @override
  State<PreviewCVScreen> createState() => _PreviewCVScreenState();
}

class _PreviewCVScreenState extends State<PreviewCVScreen> {
  WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? bytes;
  final pdf = pw.Document();
  String avatar = '';

  void init() async {
    avatar = Modular.get<ProviderAuth>().user.avatar.toString();
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = context.watch<ProviderProfile>();
    context.watch<ProviderAuth>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF'),
      ),
      body: WidgetsToImage(
          controller: controller, child: buildCV(size, context, avatar)),
      floatingActionButton: FloatingActionButton(
        child: provider.isLoadingUpdateProfile
            ? const CircularProgressIndicator()
            : const Icon(Icons.image_outlined),
        onPressed: () async {
          provider.updateLoadingUpdateProfile(true);
          final bytes = await controller.capture();
          this.bytes = bytes;
          createPDF(bytes!);
          await savePDF();
          Modular.to.navigate(RoutePath.listProfile);
        },
      ),
    );
  }

  createPDF(Uint8List bytes) {
    final image = pw.MemoryImage(bytes);
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Center(child: pw.Image(image));
      },
    ));
  }

  savePDF() async {
    try {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir?.path}/file.pdf');
      await file.writeAsBytes(await pdf.save());
      await Modular.get<ProviderProfile>().updateProfile(
          id: widget.idCV, name: widget.nameCV, pathCV: file.path);
      showPrintedMessage('success', 'saved to document');
    } catch (e) {
      showPrintedMessage('error', e.toString());
    }
  }

  showPrintedMessage(String title, String msg) {
    Flushbar(
      title: title,
      message: msg,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        Icons.info,
        color: primaryColor,
      ),
    ).show(context);
  }

  Widget buildCV(Size size, BuildContext context, String avatar) {
    final provider = context.watch<ProviderApp>();
    List<ExperienceModel> listExperience = provider.listExperience;
    List<SchoolModel> listSchool = provider.listSchool;
    List<SkillModel> listSkill = provider.listSkill;
    return InteractiveViewer(
      maxScale: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: size.width * 1.4142,
        width: size.width + 200,
        color: Colors.pink[50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: (size.width - 20) / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: primaryColor),
                    child: Text(
                      widget.language == 'Tiếng Anh'
                          ? 'Work experience'
                          : 'Kinh nghiệm làm việc',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                  ),

                  for (int i = 0; i < listExperience.length; i++)
                    ExperienceItemPDF(
                        position: listExperience[i].position,
                        nameCompany: listExperience[i].nameCompany,
                        description: listExperience[i].description,
                        to: listExperience[i].to,
                        from: listExperience[i].from),

                  //eduction
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(bottom: 8, top: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: primaryColor),
                    child: Text(
                      widget.language == 'Tiếng Anh' ? 'Education' : 'Học vấn',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                  ),
                  for (int i = 0; i < listSchool.length; i++)
                    ExperienceItemPDF(
                        position: listSchool[i].major,
                        nameCompany: listSchool[i].nameSchool,
                        description: listSchool[i].description,
                        to: listSchool[i].to,
                        from: listSchool[i].from),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: primaryColor),
                    child: Text(
                      widget.language == 'Tiếng Anh' ? 'Skills' : 'Kỹ năng',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                  ),

                  for (int i = 0; i < listSkill.length; i++)
                    SkillItemPDF(
                        nameSkill: listSkill[i].nameSkill,
                        description: listSkill[i].description)
                ],
              ),
            ),
            SizedBox(
              width: (size.width - 20) / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.imageFile == null
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: (size.width - 170) / 2,
                          height: (size.width - 170) / 2,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(getAvatarUser(avatar)),
                                  fit: BoxFit.fill)),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Image.file(
                            widget.imageFile!,
                            height: (size.width - 170) / 2,
                            width: (size.width - 170) / 2,
                            fit: BoxFit.fill,
                          ),
                        ),
                  Text(
                    widget.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14),
                  ),
                  Text(
                    widget.position,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      widget.language == 'Tiếng Anh'
                          ? 'Contact infomation'
                          : 'THÔNG TIN',
                      style: const TextStyle(
                          fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const InformationCVItem(
                      icon: ImageFactory.calendar, content: '12/02/2001'),
                  InformationCVItem(
                      icon: ImageFactory.call, content: widget.phoneNumber),
                  InformationCVItem(
                      icon: ImageFactory.gmail, content: widget.email),
                  if (widget.link != '')
                    InformationCVItem(
                        icon: ImageFactory.link, content: widget.link!),
                  InformationCVItem(
                      icon: ImageFactory.locationOutline,
                      content: widget.address),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: primaryColor),
                    child: Text(
                      widget.language == 'Tiếng Anh'
                          ? 'Career goals'
                          : 'Mục tiêu nghề nghiệp',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: (size.width - 20) / 2,
                    child: Text(
                      widget.careerGoals,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
