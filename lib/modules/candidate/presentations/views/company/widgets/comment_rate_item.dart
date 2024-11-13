import 'package:app/configs/image_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentRateItem extends StatefulWidget {
  const CommentRateItem({super.key});

  @override
  State<CommentRateItem> createState() => _CommentRateItemState();
}

class _CommentRateItemState extends State<CommentRateItem> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: Colors.grey)),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      height: 160,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(100),
                    image: const DecorationImage(
                        image: AssetImage(ImageFactory.editCV),
                        fit: BoxFit.fill)),
              ),
              Container(
                margin: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Joel Oliveira',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'January 6, 2022',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    )
                  ],
                ),
              ),
              Expanded(child: Container()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    ImageFactory.star,
                    width: 20,
                    height: 20,
                  ),
                  SvgPicture.asset(
                    ImageFactory.star,
                    width: 20,
                    height: 20,
                  ),
                  SvgPicture.asset(
                    ImageFactory.star,
                    width: 20,
                    height: 20,
                  ),
                  SvgPicture.asset(
                    ImageFactory.star,
                    width: 20,
                    height: 20,
                  ),
                  SvgPicture.asset(
                    ImageFactory.star,
                    width: 20,
                    height: 20,
                  ),
                ],
              )
            ],
          ),
          const Text(
            'Work-life balance - Now, it depends on what you look at when I say Work-life Balance. Are you looking for 9-6 job? Or you want to just work for 9 hours, or you have constraints due to other activities you do at home.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
