// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// class BarChartWidget1 extends StatelessWidget {
//   const BarChartWidget1({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MyThemeModel>(
//       builder: (context, themeModel, child) {
//         BarChartRodData makeRodData(double y) {
//           return BarChartRodData(
//             toY: y,
           
//             width: 14,
//             borderRadius: BorderRadius.circular(2),
//             backDrawRodData: BackgroundBarChartRodData(
//               show: true,
             
//               : 140,
//             ),
//           );
//         }

//         return Column(
//           children: [
//             const TopSectionWidget(
//               title: 'Bar Graph',
//               legends: [],
//               padding: EdgeInsets.only(left: 8, right: 18, top: 8, bottom: 8),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 18, top: 18, bottom: 18),
//                 child: BarChart(
//                   BarChartData(
//                     barGroups: [
//                       BarChartGroupData(x: 0, barRods: [makeRodData(20)]),
//                       BarChartGroupData(x: 1, barRods: [makeRodData(40)]),
//                       BarChartGroupData(x: 2, barRods: [makeRodData(30)]),
//                       BarChartGroupData(x: 3, barRods: [makeRodData(60)]),
//                       BarChartGroupData(x: 4, barRods: [makeRodData(75)]),
//                       BarChartGroupData(x: 5, barRods: [makeRodData(35)]),
//                       BarChartGroupData(x: 6, barRods: [makeRodData(42)]),
//                       BarChartGroupData(x: 7, barRods: [makeRodData(33)]),
//                       BarChartGroupData(x: 8, barRods: [makeRodData(60)]),
//                       BarChartGroupData(x: 9, barRods: [makeRodData(90)]),
//                       BarChartGroupData(x: 10, barRods: [makeRodData(86)]),
//                       BarChartGroupData(x: 11, barRods: [makeRodData(120)]),
//                     ],
//                     titlesData: FlTitlesData(
//                       rightTitles: SideTitles(showTitles: false),
//                       topTitles: SideTitles(showTitles: false),
//                       bottomTitles: SideTitles(
//                         reservedSize: 6,
//                         showTitles: true,
//                         getTitles: (xValue) {
//                           switch (xValue.toInt()) {
//                             case 0:
//                               return 'Jan';
//                             case 1:
//                               return 'Feb';
//                             case 2:
//                               return 'Mar';
//                             case 3:
//                               return 'Apr';
//                             case 4:
//                               return 'May';
//                             case 5:
//                               return 'Jun';
//                             case 6:
//                               return 'Jul';
//                             case 7:
//                               return 'Aug';
//                             case 8:
//                               return 'Sep';
//                             case 9:
//                               return 'Oct';
//                             case 10:
//                               return 'Nov';
//                             case 11:
//                               return 'Dec';
//                             default:
//                               throw StateError('Not supported');
//                           }
//                         },
//                       ),
//                       leftTitles: SideTitles(
//                         showTitles: true,
//                         interval: 20,
//                         reservedSize: 32,
//                       ),
//                     ),
//                     maxY: 140,
//                     gridData: FlGridData(show: false),
//                     borderData: FlBorderData(show: false),
//                   ),
//                   swapAnimationDuration: Duration.zero,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ui_challenge_7/main.dart';
// import 'package:ui_challenge_7/my_theme_model.dart';

// class TopSectionWidget extends StatelessWidget {
//   final String title;
//   final List<Legend> legends;
//   final EdgeInsets padding;

//   const TopSectionWidget({
//     Key? key,
//     required this.title,
//     required this.legends,
//     this.padding = EdgeInsets.zero,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MyThemeModel>(
//       builder: (context, themeModel, child) {
//         return Container(
//           height: 20,
//           margin: padding,
//           child: Row(
//             children: [
//               Text(title, style: TextStyle(color: themeModel.isDark() ? const Color(0xFF9595A4) : Color(0xFF040420), fontWeight: FontWeight.bold, fontSize: 12)),
//               Expanded(child: Container(), flex: 5),
//               ...legends
//                   .map(
//                     (e) => Row(
//                   children: [
//                     _LegendWidget(legend: e),
//                     const SizedBox(width: 12)
//                   ],
//                 ),
//               )
//                   .toList(),
//               Expanded(child: Container(), flex: 1),
//               const Text('2019', style: TextStyle(color: Color(0xFFA7A7B7))),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _LegendWidget extends StatelessWidget {
//   final Legend legend;

//   const _LegendWidget({
//     Key? key,
//     required this.legend,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: legend.color,
//             borderRadius: const BorderRadius.all(Radius.circular(4)),
//           ),
//         ),
//         const SizedBox(width: 4),
//         Text(legend.title, style: const TextStyle(color: Color(0xFFA7A7B7))),
//       ],
//     );
//   }
// }

// class Legend {
//   final String title;
//   final Color color;

//   Legend({
//     required this.title,
//     required this.color,
//   });
// }
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class MyThemeModel extends ChangeNotifier {
//   bool _isDark = true;

//   ThemeMode currentTheme() {
//     return _isDark ? ThemeMode.dark : ThemeMode.light;
//   }

//   bool isDark() {
//     return currentTheme() == ThemeMode.dark;
//   }

//   void switchTheme() {
//     _isDark = !_isDark;
//     notifyListeners();
//   }
// }