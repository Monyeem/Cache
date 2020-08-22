import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:toast/toast.dart';
// import 'cart.dart';
// import 'package:provider/provider.dart';
import 'dart:async';
// import 'cart_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

List storedata = [];
List filterdata = [];

String name;
String id;
var image;
var price;
int quantity;
var q = 0;
double mydoubleprice;
var elementCount;

class ProductList extends StatefulWidget {
  static String id = 'product';

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String replaceBanglaNumber(String input) {
    const english = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    const bangla = ["১", "২", "৩", "৪", "৫", "৬", "৭", "৮", "৯", "০"];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(bangla[i], english[i]);
    }

    return input;
  }

  bool isSearching = false;
  var isLoading = false;

  Future<bool> getFoodData() async {
    //get the save pid usign Sharedpreferrences
    SharedPreferences pref = await SharedPreferences.getInstance();
    var pid = pref.getString('pid');

    String url =
        'https://app.ringersoft.com/api/ringersoftfoodapp/food/$pid?fbclid=IwAR3OfylOShIlzWs7pQEt5kLSyBfQhLrjhlWcbA4P6GIr-GUj0WDQaDgjTd0';

    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        filterdata = storedata = json.decode(response.body.toString());
        isLoading = true;
      });
    }

    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFoodData();
  }

  void _filterCountries(value) {
    setState(() {
      filterdata = storedata
          .where((index) =>
              index['name'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            //TopAppBar
            Padding(
                padding: const EdgeInsets.only(top: 25, left: 2, right: 2),
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
                      child: Row(children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 38,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Container(
                          width: 180,
                          height: 50,
                          child: TextField(
                            onChanged: (value) {
                              _filterCountries(value);
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
                          width: 15,
                        ),

                        //  GestureDetector(
                        //     // onTap: () => Navigator.of(context)
                        //     //     .push(MaterialPageRoute(
                        //     //   builder: (context) => CartScreen(),
                        //     // )),
                        //     child: Stack(
                        //       fit: StackFit.loose,
                        //       overflow: Overflow.clip,
                        //       alignment: AlignmentDirectional.topStart,
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.only(
                        //               top: 12,
                        //               bottom: 14,
                        //               left: 8,
                        //               right: 8),
                        //           child: Icon(
                        //             Icons.add_shopping_cart,
                        //             size: 42,
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //         Align(
                        //           alignment: Alignment.topLeft,
                        //           child: Container(
                        //             width: 18,
                        //             height: 18,
                        //             decoration: BoxDecoration(
                        //               shape: BoxShape.circle,
                        //               color: Colors.blue,
                        //             ),
                        //             child: Center(
                        //               child: Text(
                        //                 '${cart.itemCount}',
                        //                 style: TextStyle(
                        //                     fontSize: 12,
                        //                     color: Colors.white),
                        //               ),
                        //             ),
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   )
                        //:
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Container(
                            child: Stack(
                              fit: StackFit.loose,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.add_shopping_cart,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          var appDir =
                                              (await getTemporaryDirectory())
                                                  .path;
                                          new Directory(appDir)
                                              .delete(recursive: true);
                                        })),
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                )),
            isLoading
                ? Expanded(
                    child: ListView.builder(
                      itemCount: filterdata.length,
                      itemBuilder: (context, index) {
                        List<int> g = [];

                        return Column(
                          children: [
                            Card(
                              elevation: 2,
                              child: Container(
                                height: MediaQuery.of(context).size.height / 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: filterdata[index]['image'],
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${filterdata[index]['name']}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              'বাজার মূল্য : ৳ ${filterdata[index]['old_price']}'),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              'আমাদের মূল্য : ৳ ${filterdata[index]['new_price']}'),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              'ডিসকাউন্ট : ৳ ${filterdata[index]['discount']}'),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RaisedButton(
                                            elevation: 8,
                                            color: Color(0xFF001440),
                                            onPressed: () {
                                              // name = filterdata[index]['name'];
                                              // id = filterdata[index]['id']
                                              //     .toString();
                                              // image =
                                              //     filterdata[index]['image'];
                                              // price = filterdata[index]
                                              //     ['new_price'];

                                              // //Bangla to english converter
                                              // var p =
                                              //     replaceBanglaNumber(price);

                                              // mydoubleprice = double.parse(p);
                                              // print('add');
                                              // var di = filterdata[index]
                                              //         ['discount']
                                              //     .toString();
                                              // var diss =
                                              //     replaceBanglaNumber(di);
                                              // double discountss =
                                              //     double.parse(diss);
                                              // print(discountss);

                                              // // quantity = 1;
                                              // openSheet(name);

                                              // setState(() {
                                              //   Provider.of<Cart>(context,
                                              //           listen: false)
                                              //       .addItem(
                                              //           id,
                                              //           name,
                                              //           mydoubleprice,
                                              //           quantity,
                                              //           image,
                                              //           discountss);
                                              // });
                                            },
                                            child: Text(
                                              'কার্টে অ্যাড করুন',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ));
  }

  // openSheet(String name) {
  //   Toast.show("পণ্য কার্টে অ্যাড করা হলো", context,
  //       backgroundColor: Colors.black,
  //       textColor: Colors.white,
  //       duration: Toast.LENGTH_SHORT,
  //       gravity: Toast.CENTER);
  // }
}

// class Showdiag extends StatefulWidget {
//   String name;
//   String id;
//   var image;
//   var price;
//   double mydoubleprice;
//   Showdiag({this.id, this.name, this.image, this.price, this.mydoubleprice});
//   @override
//   _ShowdiagState createState() => _ShowdiagState();
// }

// class _ShowdiagState extends State<Showdiag> {
//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<Cart>(context, listen: false);

//     return AlertDialog(
//       contentPadding: EdgeInsets.all(2),
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//       content: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.cancel,
//                   size: 25,
//                 ),
//                 onPressed: () => Navigator.of(context).pop(),
//               )
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'পণ্য এর তালিকা',
//                 style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w700),
//               ),
//             ],
//           ),
//           Expanded(
//             child: ListView.builder(
//                 itemCount: cart.items.length,
//                 itemBuilder: (ctx, i) => CartPdt(
//                     cart.items.values.toList()[i].id,
//                     cart.items.keys.toList()[i],
//                     cart.items.values.toList()[i].price,
//                     cart.items.values.toList()[i].quantity,
//                     cart.items.values.toList()[i].name,
//                     cart.items.values.toList()[i].image,
//                     cart.items.values.toList()[i].discount)),
//           ),
//           Container(
//             width: double.infinity,
//             child:
//                 Text('প্রিয় গ্রাহক ,আপানকে সর্বনিম্ন ৫০০ টাকার বাজার করতে হবে'),
//           )
//         ],
//       ),
//       actions: <Widget>[
//         // usually buttons at the bottom of the dialog
//         FlatButton(
//           child: new Text("$price"),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//     );
//   }
// }
