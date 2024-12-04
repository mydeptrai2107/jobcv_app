// ignore_for_file: deprecated_member_use

import 'package:app/configs/image_factory.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_outline.dart';
import 'package:app/shared/utils/format.dart';
import 'package:app/shared/utils/notiface_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_input_formatter/money_input_formatter.dart';

class SalaryCalculationScreen extends StatefulWidget {
  const SalaryCalculationScreen({super.key});

  @override
  State<SalaryCalculationScreen> createState() =>
      _SalaryCalculationScreenState();
}

class _SalaryCalculationScreenState extends State<SalaryCalculationScreen> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController insuranceController = TextEditingController();
  TextEditingController numberPersonController =
      TextEditingController(text: '0');

  bool isCheckbox = false;
  bool isShowCalculation = false;
  double net = 0;
  double gross = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Cổng tra cứu lương'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: size.width,
        height: size.height,
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  const Text(
                    'Công cụ tính lương   ',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                  SvgPicture.asset(
                    ImageFactory.question,
                    color: primaryColor,
                    width: 19,
                    height: 19,
                  )
                ],
              ),
            ),
            const Text(
              '(Áp dụng quy định mới từ 1/7/2020)',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.black54),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Thu nhập',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black87),
            ),
            Container(
              margin: const EdgeInsets.only(top: 7),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: TextField(
                inputFormatters: [MoneyInputFormatter()],
                keyboardType: TextInputType.number,
                controller: incomeController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nhập số tiền, VD: 15,000,000',
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Mức lương đóng bảo hiểm',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black87),
            ),
            Container(
              margin: const EdgeInsets.only(top: 7),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: TextField(
                enabled: isCheckbox,
                inputFormatters: [MoneyInputFormatter()],
                keyboardType: TextInputType.number,
                controller: insuranceController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Điền mức đóng bảo hiểm',
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: isCheckbox,
                  onChanged: (value) {
                    setState(() {
                      isCheckbox = value!;
                    });
                  },
                ),
                const Text(
                  'Mức đóng bảo hiểm khác',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Colors.black87),
                ),
              ],
            ),
            const Text(
              'Số người phụ thuộc',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black87),
            ),
            Container(
              margin: const EdgeInsets.only(top: 7),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: numberPersonController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Số người phụ thuộc',
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            if (isShowCalculation) buildNetGross(gross, net, size),
            if (isShowCalculation) buildOwner(gross, size),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
        height: 60,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: ButtonApp(
                  onPress: () {
                    if (incomeController.text.trim() == '') {
                      notifaceError(context, 'Thu nhập không phù hợp');
                      return;
                    }
                    setState(() {
                      gross = netToGross(double.parse(
                          Format.formatMoneyToString(incomeController.text)));
                      net = double.parse(
                          Format.formatMoneyToString(incomeController.text));
                      isShowCalculation = true;
                    });
                  },
                  borderRadius: 100,
                  title: 'Net ☞ Gross',
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ButtonOutline(
                  onPress: () {
                    if (incomeController.text.trim() == '') {
                      notifaceError(context, 'Thu nhập không phù hợp');
                      return;
                    }
                    setState(() {
                      net = grossToNet(double.parse(
                          Format.formatMoneyToString(incomeController.text)));
                      gross = double.parse(
                          Format.formatMoneyToString(incomeController.text));
                      isShowCalculation = true;
                    });
                  },
                  borderRadius: 100,
                  title: 'Gross ☞ Net',
                  paddingvertical: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  double netToGross(double net) {
    double input = insuranceController.text == ''
        ? 0
        : double.parse(
            Format.formatMoneyToString(insuranceController.text.toString()));
    double thunhaptruocthue = thunhapchiuthue(net) <= 0
        ? net
        : thunhapchiuthue(net) +
            (11000000 + 4400000 * int.parse(numberPersonController.text));
    double gross = 0;
    if (isCheckbox) {
      gross = thunhaptruocthue + bhxh(gross) + bhyt(gross) + input * 0.01;
    } else {
      gross = thunhaptruocthue * 100 / 89.5 > 1490000 * 20
          ? thunhaptruocthue +
              1490000 * 20 * 0.095 +
              (thunhaptruocthue + 1490000 * 20 * 0.095) / 99
          : (thunhapchiuthue(net) +
                  (11000000 +
                      4400000 * int.parse(numberPersonController.text))) *
              100 /
              89.5;
    }
    return gross;
  }

  double thunhapchiuthue(double net) {
    double thunhapquydoi =
        net - 11000000 - 4400000 * int.parse(numberPersonController.text);
    double thunhaptinhthue = 0;
    if (thunhapquydoi <= 0) {
      thunhaptinhthue = 0;
    } else if (thunhapquydoi > 0 && thunhapquydoi <= 4750000) {
      thunhaptinhthue = thunhapquydoi / 0.95;
    } else if (thunhapquydoi > 4750000 && thunhapquydoi <= 9250000) {
      thunhaptinhthue = (thunhapquydoi - 250000) / 0.9;
    } else if (thunhapquydoi > 9250000 && thunhapquydoi <= 16050000) {
      thunhaptinhthue = (thunhapquydoi - 750000) / 0.85;
    } else if (thunhapquydoi > 16050000 && thunhapquydoi <= 27250000) {
      thunhaptinhthue = (thunhapquydoi - 1650000) / 0.8;
    } else if (thunhapquydoi > 27250000 && thunhapquydoi <= 42250000) {
      thunhaptinhthue = (thunhapquydoi - 3250000) / 0.75;
    } else if (thunhapquydoi > 42250000 && thunhapquydoi <= 61850000) {
      thunhaptinhthue = (thunhapquydoi - 5850000) / 0.7;
    } else if (thunhapquydoi > 61850000) {
      thunhaptinhthue = (thunhapquydoi - 9850000) / 0.65;
    }

    return thunhaptinhthue;
  }

  double grossToNet(double gross) {
    double thunhaptruocthue = 0;
    double input =
        double.parse(Format.formatMoneyToString(insuranceController.text));
    if (isCheckbox) {
      thunhaptruocthue = gross - input * 0.01 - bhyt(gross) - bhxh(gross);
    } else {
      if (gross < 1490000 * 20) {
        thunhaptruocthue = gross * 0.895;
      } else {
        thunhaptruocthue = gross - gross * 0.01 - 1490000 * 20 * 0.095;
      }
    }
    double thunhapchiuthue = thunhaptruocthue -
        11000000 -
        4400000 * int.parse(numberPersonController.text);
    double thue = tinhthue(thunhapchiuthue);
    double net = thunhaptruocthue - thue;
    return net;
  }

  String roundToThreeDecimalPlaces(double number) {
    return number.toStringAsFixed(0);
  }

  double tinhthue(double thunhapchiuthue) {
    double thue = 0;
    if (thunhapchiuthue <= 5000000) {
      thue = thunhapchiuthue * 5 / 100;
    } else if (thunhapchiuthue > 5000000 && thunhapchiuthue <= 10000000) {
      thue = 250000 + (thunhapchiuthue - 5000000) * 0.1;
    } else if (thunhapchiuthue > 10000000 && thunhapchiuthue <= 18000000) {
      thue = 250000 + 500000 + (thunhapchiuthue - 10000000) * 0.15;
    } else if (thunhapchiuthue > 18000000 && thunhapchiuthue <= 32000000) {
      thue = 250000 + 500000 + 1200000 + (thunhapchiuthue - 18000000) * 0.2;
    } else if (thunhapchiuthue > 32000000 && thunhapchiuthue <= 52000000) {
      thue = 250000 +
          500000 +
          1200000 +
          2800000 +
          (thunhapchiuthue - 32000000) * 0.25;
    } else if (thunhapchiuthue > 52000000 && thunhapchiuthue <= 80000000) {
      thue = 250000 +
          500000 +
          1200000 +
          2800000 +
          5000000 +
          (thunhapchiuthue - 52000000) * 0.3;
    } else if (thunhapchiuthue > 80000000) {
      thue = 250000 +
          500000 +
          1200000 +
          2800000 +
          5000000 +
          8400000 +
          (thunhapchiuthue - 800000000) * 0.35;
    }
    return thue;
  }

  double bhxh(double? gross) {
    if (isCheckbox) {
      double input =
          double.parse(Format.formatMoneyToString(insuranceController.text));
      if (input > 1490000 * 20) {
        return 1490000 * 20 * 0.08;
      } else {
        return input * 0.08;
      }
    } else {
      if (gross! > 1490000 * 20) {
        return 1490000 * 20 * 0.08;
      } else {
        return gross * 0.08;
      }
    }
  }

  double bhtnld(double? gross) {
    if (isCheckbox) {
      double input =
          double.parse(Format.formatMoneyToString(insuranceController.text));
      if (input > 1490000 * 20) {
        return 1490000 * 20 * 0.005;
      } else {
        return input * 0.005;
      }
    } else {
      if (gross! > 1490000 * 20) {
        return 1490000 * 20 * 0.005;
      } else {
        return gross * 0.005;
      }
    }
  }

  double bhyt(double? gross) {
    if (isCheckbox) {
      double input =
          double.parse(Format.formatMoneyToString(insuranceController.text));
      if (input > 1490000 * 20) {
        return 1490000 * 20 * 0.015;
      } else {
        return input * 0.015;
      }
    } else {
      if (gross! > 1490000 * 20) {
        return 1490000 * 20 * 0.015;
      } else {
        return gross * 0.015;
      }
    }
  }

  Widget buildNetGross(double gross, double net, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Dieenx giai
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.5),
                  left: BorderSide(color: Colors.grey, width: 0.5),
                  right: BorderSide(color: Colors.grey, width: 0.5))),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Diễn giải',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Text(
                '(VNĐ)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),

        Container(
          height: 270,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lương GROSS',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor),
                  ),
                  Text(
                      Format.formatStringToMoney(
                          roundToThreeDecimalPlaces(gross)),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bảo hiểm xã hội (8%)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                      Format.formatStringToMoney(
                          roundToThreeDecimalPlaces(bhxh(gross))),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bảo hiểm y tế (1.5%)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                      Format.formatStringToMoney(
                          roundToThreeDecimalPlaces(bhyt(gross))),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bảo hiểm thất nghiệp (1%)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                      isCheckbox
                          ? Format.formatStringToMoney(
                              roundToThreeDecimalPlaces(double.parse(
                                      Format.formatMoneyToString(
                                          insuranceController.text)) *
                                  0.01))
                          : Format.formatStringToMoney(
                              roundToThreeDecimalPlaces(gross * 0.01)),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thu nhập trước thuế',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                      Format.formatStringToMoney(roundToThreeDecimalPlaces(
                          net + tinhthue(thunhapchiuthue(net)))),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Giảm trừ gia cảnh bản thân',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text('11 000 000',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giảm trừ gia cảnh người phụ thuộc',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                      Format.formatStringToMoney(roundToThreeDecimalPlaces(
                          4400000.0 * int.parse(numberPersonController.text))),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thu nhập chịu thuế',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                      Format.formatStringToMoney(
                          roundToThreeDecimalPlaces(thunhapchiuthue(net))),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thuế thu nhập cá nhân',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                      Format.formatStringToMoney(roundToThreeDecimalPlaces(
                          tinhthue(thunhapchiuthue(net)))),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lương NET',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor),
                  ),
                  Text(
                      Format.formatStringToMoney(
                          roundToThreeDecimalPlaces(net)),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildOwner(double gross, Size size) {
    double bhtn = isCheckbox
        ? double.parse(Format.formatMoneyToString(insuranceController.text)) *
            0.01
        : gross * 0.01;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Dieenx giai
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.5),
                  left: BorderSide(color: Colors.grey, width: 0.5),
                  right: BorderSide(color: Colors.grey, width: 0.5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (size.width - 60) / 2,
                child: const Text(
                  'Người sử dụng lao động trả',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const Text(
                '(VNĐ)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),

        Container(
          height: 270,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lương GROSS',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor),
                  ),
                  Text(
                      Format.formatStringToMoney(
                          roundToThreeDecimalPlaces(gross)),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bảo hiểm xã hội (17%)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                      Format.formatStringToMoney(
                          roundToThreeDecimalPlaces(bhxh(gross) / 8 * 17)),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bảo hiểm y tế',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                      Format.formatStringToMoney(
                          roundToThreeDecimalPlaces(bhyt(gross) * 2)),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width / 2,
                    child: const Text(
                      'Bảo hiểm tai nạn lao động (0.5 %)',
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                      Format.formatStringToMoney(
                          roundToThreeDecimalPlaces(bhtnld(gross))),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bảo hiểm thất nghiệp',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                      Format.formatStringToMoney(
                          roundToThreeDecimalPlaces(bhtn)),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng cộng',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor),
                  ),
                  Text(
                      Format.formatStringToMoney(roundToThreeDecimalPlaces(
                          gross +
                              bhxh(gross) / 8 * 17 +
                              bhyt(gross) * 2 +
                              bhtnld(gross) +
                              bhtn)),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
