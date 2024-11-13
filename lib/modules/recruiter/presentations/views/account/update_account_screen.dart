import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/recruiter/data/provider/recruiter_provider.dart';
import 'package:app/shared/presentations/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({super.key});

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController contactController = TextEditingController();

  final TextEditingController infoController = TextEditingController();

  final TextEditingController introController = TextEditingController();

  final TextEditingController addressController = TextEditingController();
  @override
  void initState() {
    final company = Modular.get<RecruiterProvider>().recruiter;

    nameController.text = company.name;
    contactController.text = company.contact;
    infoController.text = company.info ?? '';
    introController.text = company.intro ?? '';
    addressController.text = company.address ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật thông tin cá nhân'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                  controller: nameController,
                  hintText: 'Tên công ty',
                  icon: const Icon(Icons.person)),
              CustomTextField(
                  controller: contactController,
                  hintText: 'Liên hệ',
                  icon: const Icon(Icons.phone)),
              CustomTextField(
                  controller: addressController,
                  hintText: 'Địa chỉ',
                  keyboardType: TextInputType.multiline,
                  icon: const Icon(Icons.location_city)),
              CustomTextField(
                  controller: infoController,
                  hintText: 'Info',
                  icon: const Icon(Icons.web)),
              CustomTextField(
                  controller: introController,
                  hintText: 'Giới thiệu',
                  keyboardType: TextInputType.multiline,
                  icon: const Icon(Icons.info)),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
          onPressed: _update,
          style: ElevatedButton.styleFrom(
              elevation: 0, backgroundColor: primaryColor),
          child: const Text(
            'Cập nhật',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  _update() async {
    final provider = Modular.get<RecruiterProvider>();
    final company = Company(
        name: nameController.text,
        contact: contactController.text,
        address: addressController.text,
        info: infoController.text,
        intro: introController.text,
        avatar: provider.recruiter.avatar,
        createdAt: provider.recruiter.createdAt,
        updatedAt: DateTime.now(),
        id: provider.recruiter.id);
    await provider.updateMe(company);
  }
}
