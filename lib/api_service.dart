import 'dart:io';

import 'package:country/country.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';

const baseUrl = "https://65f2c329105614e6549eb841.mockapi.io/api";

abstract class ApiService {
  Future<List<Country>?> getCountries();
  Future<void> delete(String? id);
  Future<Country?> getCountry(String? id);
  Future<void> saveCountry(Country country, File file);
}
class ApiServiceImpl extends ApiService {

  final _checker = InternetConnectionChecker();
  final _storage = FirebaseStorage.instance;

  @override
  Future<List<Country>?> getCountries() async {
    try {
      // if(!await _checker.hasConnection) {
      //   return null;
      // }
      final header = {
        "Authorization": "563492ad6f91700001000001dc912faa4865445694b8ccc566067984"
      };
      final response = await http.get(Uri.parse('$baseUrl/country'),headers: header);
      if(response.statusCode == 200) {
        final jsonString = json.decode(response.body) as List;
        return jsonString.map((e) => Country.fromJson(e)).toList();
      }
      return [];
    } catch(e) {
      print(e);
    }
  }

  @override
  Future<void> delete(String? id) async {
    await http.delete(Uri.parse('$baseUrl/country/$id'));
  }

  @override
  Future<Country?> getCountry(String? id) async {
    if(!await _checker.hasConnection) {
      return null;
    }
    final response = await http.get(Uri.parse('$baseUrl/country/$id'));
    if(response.statusCode == 200) {
      return Country.fromJson(json.decode(response.body) as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<void> saveCountry(Country country, File file) async {
    final uploadTask = await _storage.ref("country_images").putFile(file);
    final url = await uploadTask.ref.getDownloadURL();

    final newCountry = {
      "name": country.name.toString(),
      "flag": url.toString(),
      "capital": country.capital.toString(),
      "population": country.population.toString(),
      "currency": country.currency.toString(),
      "desc": country.desc.toString(),
      "ncode": country.ncode.toString(),
      "ccode": country.ccode.toString()
    };

    await http.post(Uri.parse('$baseUrl/country'), body: newCountry);
  }
}