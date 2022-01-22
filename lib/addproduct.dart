import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab3/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab3/productpage.dart';
import 'package:ndialog/ndialog.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({ Key? key }) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late double screenHeight, screenWidth, resWidth;
  File? _image;
  var pathAsset = "assets/images/logo_camera.png";
  final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

  final TextEditingController _productNameEditingController = TextEditingController();
  final TextEditingController _productDescriptionEditingController = TextEditingController();
  final TextEditingController _productPriceEditingController = TextEditingController();
  final TextEditingController _productQuantityEditingController = TextEditingController();
  final TextEditingController _productStateEditingController = TextEditingController();
  final TextEditingController _productLocEditingController = TextEditingController();

  late Position _currentPosition;
  String curaddress = "Changlun";
  String curstate = "Kedah";

  @override
  void initState() {
    super.initState();
    _determinePermission();
  }
  
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
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.red,
                      Colors.blue
                ])          
            ),        
        ),      
        title: const Text("New Product"),
          leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (content)=> const ProductPage()))),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: resWidth,
            child: Column(
              children: [
                SizedBox(
                    height: screenHeight / 2,
                    child: GestureDetector(
                      onTap: _selectImage,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Container(
                          decoration: BoxDecoration(
                          boxShadow:[ 
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.7), 
                              spreadRadius: 5, 
                              blurRadius: 7, 
                              offset: const Offset(0, 2), 
                          ),
                          ],
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image!) as ImageProvider,
                            fit: BoxFit.fill,
                          ),
                        )),
                      ),
                    )),
                Card(  
                  elevation: 10,
                  color: Colors.pink[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty || (val.length < 3)
                                  ? "Product name must be longer than 3"
                                  : null,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus);
                              },
                              controller: _productNameEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Product Name',
                                  labelStyle: TextStyle(),
                                  icon: Icon(
                                    Icons.create,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty || (val.length < 3)
                                  ? "Product description must be longer than 3"
                                  : null,
                              focusNode: focus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus1);
                              },
                              maxLines: 5,
                              controller: _productDescriptionEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Product Description',
                                  alignLabelWithHint: true,
                                  labelStyle: TextStyle(),
                                  icon: Icon(
                                    Icons.description_outlined,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )
                                )
                              ),
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) => val!.isEmpty
                                        ? "Product price must contain value"
                                        : null,
                                    focusNode: focus1,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context).requestFocus(focus2);
                                    },
                                    controller: _productPriceEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Product Price',
                                        labelStyle: TextStyle(),
                                        icon: Icon(
                                          Icons.price_change_outlined
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ))),
                              ),
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) => val!.isEmpty
                                        ? "Quantity should be more than 0"
                                        : null,
                                    focusNode: focus2,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context).requestFocus(focus3);
                                    },
                                    controller: _productQuantityEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Product Quantity',
                                        labelStyle: TextStyle(),
                                        icon: Icon(
                                          Icons.production_quantity_limits,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ))),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) =>
                                        val!.isEmpty || (val.length < 3)
                                            ? "Current State"
                                            : null,
                                    enabled: false,
                                    controller: _productStateEditingController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: 'Current States',
                                        labelStyle: TextStyle(),
                                        icon: Icon(
                                          Icons.flag,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ))),
                              ),
                              Flexible(
                                  flex: 5,
                                  child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      enabled: false,
                                      validator: (val) =>
                                          val!.isEmpty || (val.length < 3)
                                              ? "Current Locality"
                                              : null,
                                      controller: _productLocEditingController,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          labelText: 'Current Locality',
                                          labelStyle: TextStyle(),
                                          icon: Icon(
                                            Icons.map,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          )))),

                            ],
                          ),
                          const SizedBox(height: 20),
                            
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Add Product', style: TextStyle(fontSize:18)),
                            onPressed: () => _newProductDialog(),
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(width: 2.0, color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          )  ,                                      
              ]),
          )))]))))
        );
  }

void _selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Select from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(resWidth * 0.3, resWidth * 0.3)),
                  child: const Text('Gallery'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectfromGallery(),
                  },
                ),
                const SizedBox(width:10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(resWidth * 0.3 , resWidth * 0.3)),
                  child: const Text('Camera'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectFromCamera(),
                  },
                ),
              ],
            ));
      },
    );
  }  

    Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.deepOrange,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  _determinePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Geolocator.openLocationSettings();
      } else {
        Navigator.of(context).pop();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Geolocator.openLocationSettings();
    }
    _getLocation();
  }

 _getLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
    setState(() {
      _productLocEditingController.text = placemarks[0].locality.toString();
      _productStateEditingController.text =placemarks[0].administrativeArea.toString();
    });
  }

  void _newProductDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in all the required fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please take a product picture",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Add this product",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addNewProduct();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
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

void _addNewProduct() {
    String _productName = _productNameEditingController.text;
    String _productDescription = _productDescriptionEditingController.text;
    String _productPrice = _productPriceEditingController.text;
    String _productQuantity = _productQuantityEditingController.text;
    String _productState = _productStateEditingController.text;
    String _productLoc = _productLocEditingController.text;

    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Adding new product.."),
        title: const Text("Processing..."));
    progressDialog.show();

    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(Uri.parse(Config.server + "/sbusiness/php/addproduct.php"), body: {
      "productName": _productName,
      "productDescription": _productDescription,
      "productPrice": _productPrice,
      "productQuantity": _productQuantity,
      "productState": _productState,
      "productLoc": _productLoc,
      "image": base64Image,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
    progressDialog.dismiss();
  }  
}
