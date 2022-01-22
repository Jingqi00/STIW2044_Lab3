import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lab3/addproduct.dart';
import 'package:lab3/config.dart';
import 'package:lab3/detailpage.dart';
import 'package:lab3/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({ Key? key }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List productlist = [];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  late ScrollController _scrollController;
  int scrollcount = 10;
  int rowcount = 2;
  int numprd = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[300],
          centerTitle: true,
          title: const Text("My Shop Home Page"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
          ),
        ),
        ), 
        body: productlist.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Column(
                children: [
                  const SizedBox(height:5),
                  const Text("All Products", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height:5),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: rowcount,
                      controller: _scrollController,
                      children: List.generate(scrollcount, (index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.6),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          ),
                        child: InkWell(
                          onTap: () => {_prodDetails(index)},
                          child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.scaleDown,
                                  imageUrl: Config.server +
                                      "/sbusiness/images/products/" +
                                      productlist[index]['productID'] +
                                      ".png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            truncateString(productlist[index]['productName'].toString()),
                                            style: TextStyle(
                                                fontSize: resWidth * 0.045,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height:8),        
                                        Text("RM " + 
                                            truncateString(productlist[index]['productPrice'].toString()),
                                            style: TextStyle(
                                                fontSize: resWidth * 0.040,
                                                fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                      ],
                                    ),
                                  )
                                ),
                            ],
                          ),
                        ));
                      }),
                    ),
                  ),
                ],
              ),
              floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                backgroundColor: Colors.pink[200],
                    children: [
                      SpeedDialChild(
                          child: const Icon(Icons.add),
                          label: "New Product",
                          labelStyle: const TextStyle(color: Colors.black),
                          labelBackgroundColor: Colors.white,
                          onTap: () => {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const AddProduct()))
                            },
                      ),
                    ],
                ),
        ));
  }

  void _loadProducts() {
    http.post(Uri.parse(Config.server + "/sbusiness/php/load_product.php"),
        body: {}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        var extractdata = data['data'];
        setState(() {
          productlist = extractdata["products"];
          numprd = productlist.length;
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        });
      } else {
        setState(() {
          titlecenter = "No Data";
        });
      }
    });
  }

  String truncateString(String str) {
    if (str.length > 15) {
      str = str.substring(0, 15);
      return str + "...";
    } else {
      return str;
    }
  }

  _prodDetails(int index) {
    Product product = Product(
        productID: productlist[index]['productID'],
        productName: productlist[index]['productName'],
        productDescription: productlist[index]['productDescription'],
        productPrice: productlist[index]['productPrice'],
        productQuantity: productlist[index]['productQuantity'],
        productState: productlist[index]['productState'],
        productLoc: productlist[index]['productLoc'],);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text(
            "View Detail?",
            style: TextStyle(),
        ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(resWidth * 0.02, resWidth * 
                    0.02),primary: Colors.lightBlue[300]),
                  child: const Text('Yes',style: TextStyle(fontSize:18)),
              onPressed: () => {
                Navigator.pop(context),
                Navigator.of(context).push(MaterialPageRoute(builder: 
                  (context) => DetailPage(product:product)))
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(resWidth * 0.02 , resWidth * 
                    0.02),primary: Colors.blue),
                  child: const Text('No',style: TextStyle(fontSize:18)),
              onPressed: () => {
                Navigator.of(context).pop(),
                const ProductPage(),
              },
              ),
            ],
          )
        );
    },
  );   
}   

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (productlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        }
      });
    }
  }
}