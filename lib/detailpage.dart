import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab3/product.dart';
import 'package:ndialog/ndialog.dart';
import 'config.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final Product product;
  const DetailPage({ Key? key, required this.product }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late double screenHeight, screenWidth, resWidth;
  int numLike = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    
  return Scaffold(
    appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.star_border,
              color: Colors.grey,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onPressed: () {_onDeleteProduct();},
          ),
        ],
      ), 
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.favorite),
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {
            numLike++;
          });
        },
      ),

      body: Container(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: CachedNetworkImage(
                    width: screenWidth,
                    fit: BoxFit.contain,
                    imageUrl: Config.server +
                        "/sbusiness/images/products/" +
                        widget.product.productID.toString() +
                        ".png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                ),
            ),
            const SizedBox(
              height: 15.0,
            ),

          Column(
            children: [
              Text(widget.product.productName.toString(),style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.favorite,
                color: Colors.red,
               ),
          const SizedBox(
            width: 5.0,
          ),
          Text("$numLike LIKE"),
          ],
          ), 

          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Table(
                      columnWidths: const {
                        0: FractionColumnWidth(0.15),
                        1: FractionColumnWidth(0.4),
                        2: FractionColumnWidth(0.5)
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.top,
                      children: [
                        TableRow(children: [
                          const Icon(Icons.description_outlined),
                          const Text('DESCRIPTION',
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(widget.product.productDescription.toString()),
                        ]),
                        
                        TableRow(children: [
                          const Icon(Icons.attach_money_outlined),
                          const Text('PRICE',
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("RM " + widget.product.productPrice.toString()),
                        ]),
                        TableRow(children: [
                          const Icon(Icons.production_quantity_limits_outlined),
                          const Text('QUANTITY',
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(widget.product.productQuantity.toString()),
                        ]),
                        TableRow(children: [
                          const Icon(Icons.outlined_flag_outlined),
                          const Text('STATE',
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(widget.product.productState.toString()),
                        ]),
                        TableRow(children: [
                          const Icon(Icons.flag_rounded),
                          const Text('CURRENT LOCALITY',
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(widget.product.productLoc.toString()),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),            
        ]))  
    );
  }

  void _onDeleteProduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Delete this product",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle(fontSize:17)),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(fontSize:20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(fontSize:20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

void _deleteProduct() {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Deleting product.."),
        title: const Text("Processing..."));
    progressDialog.show();
    http.post(Uri.parse(Config.server + "/sbusiness/php/delete_product.php"),
        body: {
          "productID": widget.product.productID,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            fontSize: 14.0);
        progressDialog.dismiss();
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
  }
}