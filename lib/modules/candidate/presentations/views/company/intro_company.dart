import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

const kBaseUrlWeather = 'api.weatherapi.com';
const keyAuth = '42dbbb5ce9d0421c92442819231403';
const kBaseUrlMapBox = 'api.mapbox.com';
const accessTokenMap =
    'pk.eyJ1Ijoic29sb21vbmFyZXMiLCJhIjoiY2xmYzczZDcxMG1vbTNxcGJlam5xZ3VqMyJ9.5Y4nfCMgKlYahPja85NAtw';
const styleMap = 'clfc7v51b000i01lixp9ser9u';

class IntroCompany extends StatefulWidget {
  const IntroCompany({super.key, required this.company});
  final Company company;

  @override
  State<IntroCompany> createState() => _IntroCompanyState();
}

class _IntroCompanyState extends State<IntroCompany> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ListView(
        children: [
          SizedBox(
            height: 15.h,
          ),
          const Text(
            'Giới thiệu',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            widget.company.intro!,
            style:
                TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.7)),
          ),
          SizedBox(
            height: 20.h,
          ),
          const Text(
            'Liên hệ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 4.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20.w,
                child: const Icon(
                  Icons.location_on,
                  color: primaryColor,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10.w),
                width: size.width - 40.w,
                child: Text(
                  widget.company.address == ''
                      ? 'Chưa cập nhật'
                      : widget.company.address.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              )
            ],
          ),
          SizedBox(
            width: size.width,
            height: 300,
            child: FlutterMap(
              options: const MapOptions(
                  initialCenter: LatLng(16.049587, 108.213824)),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://$kBaseUrlMapBox/styles/v1/solomonares/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
                  additionalOptions: const {
                    'accessToken': accessTokenMap,
                    'mapStyleId': styleMap
                  },
                ),
                const MarkerLayer(
                  markers: [
                    Marker(
                        point:  LatLng(16.049587, 108.213824),
                        child:  Icon(Icons.location_on))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
