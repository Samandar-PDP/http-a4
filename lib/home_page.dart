import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:country/add_page.dart';
import 'package:country/api_service.dart';
import 'package:country/detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'country.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _api = ApiServiceImpl();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 50),
        child:  ClipRRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                     height: 80,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 14.0),
                      child: Center(child: Text("Countries",style: TextStyle(fontSize: 20),)),
                    ),
                  )),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        displacement: MediaQuery.of(context).size.height / 9,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        //  _api.getCountries();
          _api.getCountries();
          setState(() {});
        },
        child: FutureBuilder(
          future: _api.getCountries(),
          builder: (context, snapshot) {
            print(snapshot.data);
            if(snapshot.data != null && snapshot.data?.isNotEmpty == true) {
              return _successField(snapshot.data ?? []);
            } else if(snapshot.data == null) {
              return const Center(child: Text("No internet connection!",style: TextStyle(fontSize: 23),));
            } else if(snapshot.data?.isEmpty == true) {
              return const Center(child: Text("Empty",style: TextStyle(fontSize: 23),),);
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddPage()));
        },
        child: const Icon(CupertinoIcons.add),
      )
    );
  }
  Widget _successField(List<Country> countries) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 4),
        child: Divider(),
      ),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return OpenContainer(
          closedColor: Colors.transparent,
          openColor: Colors.transparent,
          closedBuilder: (context, index) => Slidable(
              key: const ValueKey(0),
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(6),
                    onPressed: (v) {
                      _delete(country.id);
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  )
                ],
              ),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(6),
                    onPressed: (v) {
                      // Navigator.
                    },
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 45,
                  foregroundImage: NetworkImage(
                      country.flag ?? ""
                  ),
                ),
                title: Text(country.name ?? ""),
                trailing: Text(country.ccode ?? ""),
              )),
          openBuilder: (context, index) => DetailPage(id: country.id),
        );
      },
    );
  }
  void _delete(String? id) {
    showDialog(context: context, builder: (context) => CupertinoAlertDialog(
      title: const Text("Delete?"),
      actions: [
        CupertinoDialogAction(child: const Text("No"),onPressed: () {
          Navigator.of(context).pop();
        }),
        CupertinoDialogAction(onPressed: () {
          _api.delete(id).then((value) {
            Navigator.of(context).pop();
            setState(() {});
          });
        },isDestructiveAction: true,child: const Text("Yes"),),
      ],
    ));
  }
}
