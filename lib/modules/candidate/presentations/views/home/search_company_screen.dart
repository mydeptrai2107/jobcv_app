import 'package:app/configs/image_factory.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/home/widgets/item_company_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Company> listCompany = [];

  initData() async {
    isSearched = true;
    _searchController.text == ''
        ? listCompany = []
        : listCompany = await Modular.get<ProviderCompany>()
            .getCompanyByName(_searchController.text);
  }

  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final provider = context.watch<ProviderCompany>();
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: primaryColor),
              borderRadius: BorderRadius.circular(10)),
          child: TextField(
            onSubmitted: (value) async {
              await initData();
            },
            controller: _searchController,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                hintText: 'Tên công ty'),
          ),
        ),
      ),
      body: provider.isLoadingSearch
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : isSearched && listCompany.isEmpty
              ? SizedBox(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(ImageFactory.searchNotFound),
                                fit: BoxFit.fill)),
                      ),
                      const Text(
                        'Không tìm thấy dữ liệu',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return ItemCompanyHorizontal(company: listCompany[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: listCompany.length),
    );
  }
}
