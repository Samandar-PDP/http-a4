import 'dart:io';

import 'package:country/api_service.dart';
import 'package:country/country.dart';
import 'package:country/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _api = ApiServiceImpl();
  final _picker = ImagePicker();
  XFile? _xFile;
  final _name = TextEditingController();
  final _capital = TextEditingController();
  final _population = TextEditingController();
  final _ccode = TextEditingController();
  final _ncode = TextEditingController();
  final _currency = TextEditingController();
  final _desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Country")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _imageSection(),
                const Gap(20),
                TextField(
                  controller: _name,
                ),
                const Gap(10),
                TextField(controller: _capital),
                const Gap(10),
                TextField(
                  controller: _ccode,
                ),
                const Gap(10),
                TextField(controller: _ncode),
                const Gap(10),
                TextField(
                  controller: _population,
                ),
                const Gap(10),
                TextField(
                  controller: _currency,
                ),
                const Gap(10),
                TextField(
                  controller: _desc,
                ),
                const Gap(10),
                ElevatedButton(onPressed: _save, child: Text("Save"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _save() {
    _api.saveCountry(Country(
      name: _name.text,
      capital: _capital.text,
      population: _population.text,
      ccode: _ccode.text,
      ncode: _ncode.text,
      desc: _desc.text,
      currency: _currency.text,
      id: "0"
    ), File(_xFile?.path ?? "")).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    });
  }

  _imageSection() {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: _pickImage,
      child: Ink(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 1)),
        child: _xFile == null
            ? const Center(
                child: Icon(CupertinoIcons.photo),
              )
            : CircleAvatar(
          foregroundImage: FileImage(File(_xFile?.path ?? "")),
        ),
      ),
    );
  }

  _pickImage() async {
    _xFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }
}
