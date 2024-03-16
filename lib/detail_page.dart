import 'package:country/api_service.dart';
import 'package:country/country.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.id});

  final String? id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _api = ApiServiceImpl();

  Country? _country;

  @override
  void initState() {
    _getCountry();
    super.initState();
  }

  _getCountry() async {
    _country = await _api.getCountry(widget.id);
    if (context.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_country?.name ?? "...")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _country == null ? _shimmer() : ListView(
          children: [
            Image.network(_country?.flag ?? "",height: 200),
            const Gap(20),
            ListTile(
              title: Text(_country?.capital ?? ""),
              subtitle: Text((_country?.population ?? 0).toString()),
              leading: Text(_country?.ccode ?? "code"),
              trailing: Text((_country?.ncode ?? 0).toString()),
            ),
            const Gap(20),
            Text(_country?.desc ?? "")
          ],
        ),
      ),
    );
  }
  _shimmer() {
    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: Shimmer.fromColors(baseColor: Colors.grey, highlightColor: Colors.greenAccent, child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12)
        ),
      )),
    );
  }
}
