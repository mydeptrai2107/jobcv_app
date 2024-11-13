import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:app/modules/candidate/presentations/views/home/widgets/item_company_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListCompanyScreen extends StatefulWidget {
  const ListCompanyScreen({super.key});

  @override
  State<ListCompanyScreen> createState() => _ListCompanyScreenState();
}

class _ListCompanyScreenState extends State<ListCompanyScreen> {
  final List<Company> _companys = [];
  int page = 1;

  bool isLoading = false;
  bool hasMore = true;

  final ScrollController _scrollController = ScrollController();

  _getCompanys() async {
    setState(() {
      isLoading = true;
    });
    List<Company> companysPaging = [];
    int maxLength = await Modular.get<ProviderCompany>().getQuantityCompany();

    companysPaging =
        await Modular.get<ProviderCompany>().getListCompanyPaging(page);
    _companys.addAll(companysPaging);
    setState(() {
      isLoading = false;
      page += 1;
      hasMore = _companys.length < maxLength;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCompanys();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading) {
        if (hasMore) {
          _getCompanys();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ProviderCompany>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Công ty nổi bật'),
        actions: [
          GestureDetector(
            onTap: () {
              Modular.to.pushNamed(RoutePath.searchCompanyScreen);
            },
            child: SvgPicture.asset(
              ImageFactory.search,
              width: 25,
              height: 25,
            ),
          )
        ],
      ),
      body: Container(
          color: Colors.grey.withOpacity(0.2),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index == _companys.length) {
                  return const SizedBox(
                    width: 30,
                    height: 30,
                    child: FittedBox(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return ItemCompanyHorizontal(company: _companys[index]);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 20,
                );
              },
              itemCount: _companys.length + (hasMore ? 1 : 0))),
    );
  }
}
