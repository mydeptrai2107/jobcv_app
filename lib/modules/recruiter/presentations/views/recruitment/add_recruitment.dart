import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/data/models/province.dart';
import 'package:app/modules/candidate/data/repositories/repository_map_vn.dart';
import 'package:app/modules/candidate/domain/use_case/get_province.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/recruiter/data/provider/recruiter_provider.dart';
import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:app/shared/presentations/widgets/custom_textfield.dart';
import 'package:app/shared/utils/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

enum Position { intern, fresher, junior, midle, senior }

class AddRecruitment extends StatelessWidget {
  const AddRecruitment({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tạo tin tuyển dụng',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        IconButton(
            onPressed: () => Modular.to.pushNamed(RoutePath.addRecruitment),
            icon: const Icon(Icons.add))
      ],
    );
  }
}

class AddRecruitmentScreen extends StatefulWidget {
  final Recruitment? recruitment;

  const AddRecruitmentScreen({super.key, this.recruitment});

  @override
  State<AddRecruitmentScreen> createState() => _AddRecruitmentScreenState();
}

class _AddRecruitmentScreenState extends State<AddRecruitmentScreen> {
  final _keyForm1 = GlobalKey<FormState>();
  final _keyForm2 = GlobalKey<FormState>();

  final TextEditingController titleController =
      TextEditingController(text: kDebugMode ? 'Junior Flutter' : null);

  final TextEditingController salaryController =
      TextEditingController(text: kDebugMode ? 'up to 1000 usd' : null);

  final TextEditingController requestController = TextEditingController();

  final TextEditingController qtyController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController positionController = TextEditingController();

  final TextEditingController benefitController = TextEditingController();

  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  List<Province> listProvince = [];
  GetProvince getProvince = GetProvince(reporitpryMap: ReporitoryMap());
  DateTime? deadline;
  String title = 'Tạo tin tuyển dụng';
  @override
  void initState() {
    getProvice();
    if (widget.recruitment != null) {
      title = 'Chỉnh sửa tin';
      titleController.text = widget.recruitment!.title ?? '';
      salaryController.text = widget.recruitment!.salary ?? '';
      requestController.text = widget.recruitment!.request ?? '';
      qtyController.text = widget.recruitment!.numberOfRecruits.toString();
      descriptionController.text = widget.recruitment!.descriptionWorking ?? '';
      positionController.text = widget.recruitment!.position ?? '';
      benefitController.text = widget.recruitment!.benefit ?? '';
      deadline = widget.recruitment!.deadline;
      experienceController.text = widget.recruitment!.experience ?? '';
      addressController.text = widget.recruitment!.address ?? '';
    }
    super.initState();
  }

  _addRecruitment() async {
    final recruitment = Recruitment(
        companyId: Modular.get<RecruiterProvider>().recruiter.id,
        title: titleController.text,
        salary: salaryController.text,
        deadline: deadline,
        workingForm: 'onsite',
        numberOfRecruits: qtyController.text,
        gender: "true",
        experience: experienceController.text,
        position: positionController.text,
        address: addressController.text.isEmpty
            ? 'Việt Nam'
            : addressController.text,
        descriptionWorking: descriptionController.text,
        request: requestController.text,
        benefit: benefitController.text,
        statusShow: true);
    if (widget.recruitment != null) {
      recruitment.id = widget.recruitment!.id;
      await Modular.get<RecruitmentProvider>().updateRecruitment(recruitment);
    } else {
      await Modular.get<RecruitmentProvider>().createRecruitment(recruitment);
    }
  }

  getProvice() async {
    listProvince = await getProvince.get();
    setState(() {});
  }

  _stepCancel() {
    if (_indexTab == 0) return;
    _indexTab--;
    setState(() {});
  }

  _stepContinue() {
    bool isNextStep = false;

    if (_indexTab == 0) {
      if (!_keyForm1.currentState!.validate()) return;
      isNextStep = true;
    } else if (_indexTab == 1) {
      if (!_keyForm2.currentState!.validate()) return;
      isNextStep = true;
    } else {
      _addRecruitment();
      return;
    }
    if (isNextStep) {
      _indexTab++;
      setState(() {});
    }
  }

  int _indexTab = 0;
  int? _selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(title),
      ),
      body: Theme(
        data: ThemeData(
            useMaterial3: true,
            canvasColor: Colors.white,
            colorScheme: const ColorScheme.light(primary: Colors.orange)),
        child: Stepper(
            elevation: 0,
            currentStep: _indexTab,
            type: StepperType.horizontal,
            onStepContinue: _stepContinue,
            onStepCancel: _stepCancel,
            controlsBuilder: (_, details) => Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text(
                        'Quay lại',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Tiếp tục'),
                    ),
                  ],
                ),
            steps: List.generate(3, (index) {
              final item = [_firstStep(), _secondStep(), _thirdStep()][index];
              return Step(
                  state: _indexTab == index
                      ? StepState.editing
                      : StepState.indexed,
                  isActive: _indexTab == index,
                  title: const Text(''),
                  content: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: item,
                  ));
            })),
      ),
    );
  }

  Widget _firstStep() => Form(
        key: _keyForm1,
        child: Column(children: [
          CustomTextField(
              controller: titleController,
              hintText: 'Tiêu đề',
              icon: const Icon(Icons.title)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: CustomTextField(
                    controller: salaryController,
                    hintText: 'Mức lương',
                    icon: const Icon(Icons.attach_money)),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(top: 12.0),
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        borderRadius: BorderRadius.circular(16.0),
                        hint: Text(
                          qtyController.text.isEmpty
                              ? 'Số lượng'
                              : qtyController.text,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                        ),
                        isExpanded: true,
                        items: ['1', '2 - 4', '5 - 7', '8 - 9', '> 10']
                            .map<DropdownMenuItem>((e) => DropdownMenuItem(
                                  value: '$e người',
                                  child: Text(
                                    '$e người',
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            qtyController.text = value;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  )),
            ],
          ),
          CustomTextField(
              controller: positionController,
              hintText: 'Vị trí',
              icon: const Icon(Icons.account_box_outlined)),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Gợi ý'),
                Wrap(
                    spacing: 8,
                    children: Position.values
                        .map((e) => ChoiceChip(
                              selectedColor: primaryColor,
                              onSelected: (value) {
                                setState(() {
                                  _selected = value ? e.index : null;
                                  positionController.text = e.name;
                                });
                              },
                              selected: _selected == e.index,
                              label: Text(e.name),
                            ))
                        .toList()),
              ],
            ),
          ),
          CustomTextField(
              controller: experienceController,
              hintText: 'Kinh nghiệm',
              icon: const Icon(Icons.timelapse_outlined)),
        ]),
      );

  Widget _secondStep() => Form(
        key: _keyForm2,
        child: Column(
          children: [
            CustomTextField(
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                hintText: 'Miêu tả',
                icon: const Icon(Icons.description_outlined)),
            CustomTextField(
                keyboardType: TextInputType.multiline,
                controller: requestController,
                hintText: 'Yêu cầu',
                icon: const Icon(Icons.request_page_outlined)),
            CustomTextField(
                keyboardType: TextInputType.multiline,
                controller: benefitController,
                hintText: 'Lợi ích',
                icon: const Icon(Icons.wysiwyg)),
          ],
        ),
      );

  Widget _thirdStep() => Column(
        children: [
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(16.0),
                  hint: Text(
                    addressController.text.isEmpty
                        ? 'Địa điểm làm việc'
                        : addressController.text,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                  isExpanded: true,
                  items: listProvince
                      .map<DropdownMenuItem>((e) => DropdownMenuItem(
                            value: e.name,
                            child: Text(
                              e.name,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      addressController.text = value;
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.timer_outlined),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _addDeadline,
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Center(
                      child: Text(
                    deadline != null
                        ? Format.formatDateTimeToYYYYmmHHmm(deadline!)
                        : 'Hạn nộp hồ sơ',
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  )),
                ),
              ),
            ],
          )
        ],
      );
  _addDeadline() async {
    final initDate = DateTime.now().add(const Duration(days: 1));
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: initDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    deadline = selectedDate ?? initDate;
    setState(() {});
  }
}
