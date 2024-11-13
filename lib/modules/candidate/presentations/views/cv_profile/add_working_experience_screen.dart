import 'package:app/configs/text_app.dart';
import 'package:app/modules/candidate/data/models/hive_models/experience_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_app.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/modules/candidate/presentations/views/widgets/compulsory_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AddWorkingExperienceScreen extends StatefulWidget {
  const AddWorkingExperienceScreen({super.key});

  @override
  State<AddWorkingExperienceScreen> createState() =>
      _AddWorkingExperienceScreenState();
}

class _AddWorkingExperienceScreenState
    extends State<AddWorkingExperienceScreen> {
  bool isExperience = true;
  bool isWorkingHere = false;
  String fromDate = '';
  String toDate = '';
  DateTime setFromDate = DateTime(2023, 01, 01);
  DateTime setToDate = DateTime(2023, 01, 01);

  final _experienceBox = Hive.box<ExperienceModel>('Experience');

  final TextEditingController _nameCompanyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProviderApp>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Add Working Experience'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        height: size.height,
        width: size.width,
        child: ListView(
          children: [
            Container(
              color: const Color.fromARGB(255, 233, 231, 231),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isExperience,
                    onChanged: (value) {
                      setState(() {
                        isExperience = value!;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  const Text(
                    'Chưa có kinh nghiệm làm việc',
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            if (isExperience)
              SizedBox(
                width: size.width,
                child: const Text(
                  TextApp.fillExperience,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            if (!isExperience)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //company name
                    const CompulsoryText(title: 'Tên Công Ty'),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(top: 5, bottom: 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: _nameCompanyController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isWorkingHere,
                          onChanged: (value) {
                            setState(() {
                              isWorkingHere = value!;
                              if (isWorkingHere) setFromDate = DateTime.now();
                            });
                          },
                          activeColor: primaryColor,
                        ),
                        const Text(
                          'Hiện tại đang làm việc ở đây',
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //To
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CompulsoryText(title: 'Từ ngày'),
                            GestureDetector(
                              onTap: () async {
                                DateTime? newToDate = await showDatePicker(
                                    context: context,
                                    initialDate: setToDate,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));

                                if (newToDate == null) return;
                                setState(() {
                                  setToDate = newToDate;
                                  var f = DateFormat('MM/yyyy');
                                  toDate = f.format(newToDate).toString();
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 7),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                width: (size.width - 50) / 2,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      toDate,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                        //From
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CompulsoryText(title: 'Đến ngày'),
                            GestureDetector(
                              onTap: () async {
                                if (!isWorkingHere) {
                                  DateTime? newFromDate = await showDatePicker(
                                      context: context,
                                      initialDate: setFromDate,
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100));

                                  if (newFromDate == null) return;
                                  setState(() {
                                    setFromDate = newFromDate;
                                    var f = DateFormat('MM/yyyy');
                                    fromDate = f.format(newFromDate).toString();
                                  });
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 7),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                width: (size.width - 50) / 2,
                                decoration: BoxDecoration(
                                    color: isWorkingHere
                                        ? Colors.grey.withOpacity(0.2)
                                        : Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isWorkingHere ? '' : fromDate,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down)
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //Position
                    const CompulsoryText(title: 'Vị trí'),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(top: 5, bottom: 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: _positionController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    //detail position
                    const Text(
                      'Mô tả chi tiết vị trí của bạn',
                      style: TextStyle(fontSize: 14),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(top: 7),
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: _descriptionController,
                        maxLines: 10,
                        cursorColor: Colors.red,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Type to add description',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.black.withOpacity(0.6), width: 1))),
        height: 80,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: ButtonApp(
            onPress: () async {
              await saveExperience();
              provider.fetchAllExperience();
              Modular.to.pop();
            },
            title: 'Lưu',
            borderRadius: 10,
            paddingvertical: 15,
          ),
        ),
      ),
    );
  }

  saveExperience() async {
    await _experienceBox.add(ExperienceModel(
        nameCompany: _nameCompanyController.text,
        to: setToDate,
        from: setFromDate,
        position: _positionController.text,
        description: _descriptionController.text));
  }
}
