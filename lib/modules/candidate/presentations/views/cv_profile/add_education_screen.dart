import 'package:app/modules/candidate/data/models/hive_models/school_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_app.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/modules/candidate/presentations/views/widgets/compulsory_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AddEducationScreen extends StatefulWidget {
  const AddEducationScreen({super.key});

  @override
  State<AddEducationScreen> createState() => _AddEducationScreenState();
}

class _AddEducationScreenState extends State<AddEducationScreen> {
  bool isWorkingHere = false;
  String fromDate = '';
  String toDate = '';
  DateTime setFromDate = DateTime(2023, 01, 01);
  DateTime setToDate = DateTime(2023, 01, 01);

  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final _boxSchool = Hive.box<SchoolModel>('School');

  @override
  void dispose() {
    _schoolNameController.dispose();
    _majorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = context.watch<ProviderApp>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Thêm học vấn'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: size.height,
        width: size.width,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //company name
                const CompulsoryText(title: 'Trường học'),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(top: 5, bottom: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: _schoolNameController,
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
                      'Hiện tại đang học ở đây',
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 50,
                            width: (size.width - 50) / 2,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 50,
                            width: (size.width - 50) / 2,
                            decoration: BoxDecoration(
                                color: isWorkingHere
                                    ? Colors.grey.withOpacity(0.2)
                                    : Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                //major
                const CompulsoryText(title: 'Chuyên ngành'),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(top: 5, bottom: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: _majorController,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),

                //description
                const Text(
                  'Mô tả',
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
              await saveSchool();
              provider.fetchAllSchool();
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

  saveSchool() async {
    await _boxSchool.add(SchoolModel(
        nameSchool: _schoolNameController.text,
        to: setToDate,
        from: setFromDate,
        major: _majorController.text,
        description: _descriptionController.text));
  }
}
