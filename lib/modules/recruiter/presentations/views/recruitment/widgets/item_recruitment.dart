import 'package:animations/animations.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/data/models/apply_model.dart';
import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'package:app/modules/recruiter/presentations/views/recruitment/detail_recruitment_screen.dart';
import 'package:app/shared/presentations/widgets/open_container_wrapper.dart';
import 'package:app/shared/provider/provider_apply.dart';
import 'package:flutter/material.dart';

import 'package:app/shared/models/recruitment_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../candidate/presentations/themes/color.dart';

class ItemRecruitment extends StatefulWidget {
  final Recruitment item;
  const ItemRecruitment({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<ItemRecruitment> createState() => _ItemRecruitmentState();
}

class _ItemRecruitmentState extends State<ItemRecruitment> {
  _removeRecruitment(String id) {
    showDialog(
        context: Modular.routerDelegate.navigatorKey.currentContext!,
        builder: (_) => AlertDialog(
              title: const Text('Bạn có muốn xoá tin này ?'),
              titleTextStyle:
                  const TextStyle(fontSize: 18, color: Colors.black),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, minimumSize: const Size(100, 40)),
                          onPressed: () => Modular.to.pop(),
                          child: const Text('Huỷ'))),
                  Flexible(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, minimumSize: const Size(100, 40)),
                          onPressed: () => Modular.get<RecruitmentProvider>()
                              .deleteRecruitment(id),
                          child: const Text('Xoá'))),
                ],
              ),
            ));
  }

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  List<Apply> applys = [];
  initData() async {
    applys = await Modular.get<ProviderApply>()
        .getListApplyByRecruitment(widget.item.id!);
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    context.watch<ProviderApply>();
    return OpenContainerWrapper(
        closedBuilder: (_, onpenContainer) => Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        widget.item.title!.toUpperCase(),
                        style: textTheme.titleSmall,
                      )),
                      GestureDetector(
                        onTap: () async {
                          await context
                              .read<RecruitmentProvider>()
                              .updateStatus(widget.item);
                        },
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6.0)),
                          child: Text(
                            widget.item.statusShow == false
                                ? 'Đang tắt'
                                : 'Đang bật',
                            style: textTheme.bodySmall!.copyWith(
                                color: widget.item.statusShow == false
                                    ? Colors.red
                                    : primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: () => Modular.to.pushNamed(
                            RoutePath.addRecruitment,
                            arguments: widget.item),
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6.0)),
                          child: const Icon(
                            Icons.edit_document,
                            color: primaryColor,
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: () => _removeRecruitment(widget.item.id!),
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6.0)),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Miêu tả',
                    style: textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.item.descriptionWorking!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Element(
                        label: 'Số lượng',
                        des: widget.item.numberOfRecruits.toString(),
                      ),
                      GestureDetector(
                        onTap: () async {},
                        child: Container(
                            height: 30,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 245, 236, 255),
                                borderRadius: BorderRadius.circular(6.0)),
                            child: Text(
                              'Có ${applys.length} ứng tuyển',
                              style: textTheme.bodySmall!.copyWith(
                                  color:
                                      const Color.fromARGB(255, 108, 76, 190)),
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await context
                              .read<RecruitmentProvider>()
                              .showDetail(widget.item);
                          onpenContainer();
                        },
                        child: Container(
                            height: 30,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6.0)),
                            child: Text(
                              'Xem chi tiết',
                              style: textTheme.bodySmall!
                                  .copyWith(color: primaryColor),
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
        transitionType: _transitionType,
        pageDetail: const DetailRecruitmentScreen());
  }
}

class Element extends StatelessWidget {
  final String label;
  final String des;
  const Element({
    Key? key,
    required this.label,
    required this.des,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6.0)),
            child: Text(
              des,
              style: textTheme.bodySmall,
            )),
      ],
    );
  }
}
