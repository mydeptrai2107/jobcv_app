import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:app/modules/candidate/presentations/views/company/widgets/tag_recuitment_item.dart';
import 'package:app/shared/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecruitmentItem extends StatefulWidget {
  const RecruitmentItem(
      {super.key, required this.recruitment, required this.company});

  final Recruitment recruitment;
  final Company company;

  @override
  State<RecruitmentItem> createState() => _RecruitmentItemState();
}

class _RecruitmentItemState extends State<RecruitmentItem> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed(RoutePath.detailRecruitment,
            arguments: [widget.recruitment, widget.company]);
      },
      child: Container(
        width: size.width,
        height: 125.h,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 40,
              child: Text(
                '${widget.recruitment.title} - ${widget.recruitment.address}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    TagRecuitmentItem(
                      icon: ImageFactory.clock,
                      title: Format.formatDateTimeToYYYYmmdd(
                          widget.recruitment.deadline!),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    TagRecuitmentItem(
                      icon: ImageFactory.location,
                      title: widget.recruitment.address!,
                    )
                  ],
                ),
                TagRecuitmentItem(
                    title: widget.recruitment.salary!,
                    icon: ImageFactory.dollar)
              ],
            )
          ],
        ),
      ),
    );
  }
}
