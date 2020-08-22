import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:future_builder_app/api/ApiServiceProvider.dart';
import 'package:future_builder_app/pojo/Data.dart';
import 'package:future_builder_app/pojo/Response.dart';
import 'ProductList.dart';
// import 'package:cached_network_image/cached_network_image.dart';

List filterdata2 = [];
List data2;
var appDir;

class BabyProduct extends StatefulWidget {
  static String id = 'baby';

  @override
  _BabyProductState createState() => _BabyProductState();
}

class _BabyProductState extends State<BabyProduct> {
  ApiServiceProvider _apiServiceProvider = new ApiServiceProvider();
  String searchString = "";
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer(Duration(seconds: 20), () => deleteCa());
  }

  deleteCa() async {
    appDir = (await getTemporaryDirectory()).path;
    new Directory(appDir).delete(recursive: true);
  }

  void _filterCountries(value) {
    setState(() {
      filterdata2 = data2
          .where((index) =>
              index['name'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            //TopAppBar
            Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Container(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        side: BorderSide.none),
                    color: Color(0xFF001440),
                    elevation: 2,
                    onPressed: () {},
                    child: Container(
                      color: Color(0xFF001440),
                      padding: EdgeInsets.all(5),
                      child: Row(children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 180,
                          height: 55,
                          child: TextField(
                            onChanged: (value) {
                              // _filterCountries(value);

                              setState(() {
                                searchString = value;
                              });
                            },
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'আপনার পছন্দের পণ্যটি এইখানে খুজুন',
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 11),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 14,
                        ),
                      ]),
                    ),
                  ),
                )),

            SizedBox(
              height: 20,
            ),
            FutureBuilder<Response>(
              future: _apiServiceProvider.getUser('3'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  filterdata2 = snapshot.data.data;

                  print(filterdata2.length);
                  return Expanded(
                    child: ListView.builder(
                        itemCount: filterdata2.length,
                        itemBuilder: (context, index) {
                          data2 = filterdata2;
                          Data user = filterdata2[index];

                          return user.name.contains(searchString)
                              ? ListTile(
                                  onTap: () {
                                    setState(() {
                                      saveId(user.id);
                                      Route route = MaterialPageRoute(
                                        builder: (context) => ProductList(
                                            // data[index],
                                            ),
                                      );
                                      Navigator.push(context, route);
                                    });
                                  },
                                  title: Text('${user.name}'),
                                  subtitle: Text(user.id),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(user.image),
                                  ),
                                )
                              : Container();
                        }),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ));
  }

  //save the pId in sharedPreferences
  void saveId(var pid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('pid', pid.toString());
  }
}
