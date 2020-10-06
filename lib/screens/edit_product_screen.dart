import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import '../providers/product.dart';
import '../providers/products.dart';
import 'dart:io';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _tagsFocusNode = FocusNode();

  //Image Upload variables
  File _image;
  String _uploadedFileURL;
  //Image Upload variables

  var _editedProduct = Product(
      id: null, title: '', price: 0, description: '', images: [], tags: '');

  var _isInit = true;
  var _isLoading = false;
  String tagsValue = "Other";
  List<String> _tags = ["Electronics", "Clothing", "Accesories", "Other"];

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'images': [],
    'tags': 'Other',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'images': [],
          'tags': _editedProduct.tags,
        };
        _imageUrlController.text = _editedProduct.images.toString();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _tagsFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  // File Choose
  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      _image = image;
      uploadFile();
      setState(() {
        
      });
      
    });
  }

  Future uploadFile() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
            _editedProduct.images.add(_uploadedFileURL);
      setState(() {
        
      });
    });
  }

  //Saving form datas

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    uploadFile();
    _form.currentState.save();
    
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  }),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  void removeImage(String index){
    _editedProduct.images.remove(index);
    Navigator.of(context).pop();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Manager'),
        actions: <Widget>[
          FlatButton(
              child: Text('Save', style: TextStyle(color: Colors.white)),
              color: Color.fromRGBO(99, 154, 103, 1),
              onPressed: _saveForm),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: new InputDecoration(
                          icon: Icon(Icons.title),
                          hintText: "Title for Item",
                          fillColor: Colors.white10,

                          //fillColor: Colors.green
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: value,
                              price: _editedProduct.price,
                              tags: _editedProduct.tags,
                              description: _editedProduct.description,
                              images: _editedProduct.images,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: new InputDecoration(
                          icon: Icon(Icons.monetization_on),
                          hintText: "Price per Item",
                          fillColor: Colors.white10,

                          //fillColor: Colors.green
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter the valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Price can not be zero or less';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: double.parse(value),
                              tags: _editedProduct.tags,
                              description: _editedProduct.description,
                              images: _editedProduct.images,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: new InputDecoration(
                          icon: Icon(Icons.description),
                          hintText: "Description",
                          fillColor: Colors.white10,

                          //fillColor: Colors.green
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a description';
                          }
                          if (value.length < 10) {
                            return 'Please at least 10 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              tags: _editedProduct.tags,
                              description: value,
                              images: _editedProduct.images,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      DropdownButton<String>(
                        underline: Container(
                          height: 1,
                          color: Color.fromRGBO(33, 140, 116, 1.0),
                        ),
                        value: _initValues['tags'],
                        hint: Text("Please Select Tag"),
                        items: _tags
                            .map((tag) => DropdownMenuItem<String>(
                                child: Text(tag), value: tag))
                            .toList(),
                        onChanged: (String newValue) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              tags: newValue,
                              description: _editedProduct.description,
                              images: _editedProduct.images,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                          setState(() {
                            _initValues['tags'] = newValue;
                          });
                        },
                      ),
                      _editedProduct.images.length == 0 ? Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Please choose an Image",style: TextStyle(fontSize: 20),),
                      )) : Row(
                      children: <Widget>[
                      for (int i = 0; i < _editedProduct.images.length; i++) Container(
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(2),
                        child: GestureDetector(onTap: (){
                          showDialog(context: context, builder: (ctx) => AlertDialog(
content: Text("Delete this image?"),
actions: <Widget>[
  FlatButton(child: Text("Delete"), onPressed:()=> removeImage(_editedProduct.images[i])),
],
                          ));
                        },
                        child: Image.network(_editedProduct.images[i], fit: BoxFit.cover,))),
                      ],  
                      ),
                      RaisedButton(
                          child: Text("Select Image"), onPressed: chooseFile),
                      RaisedButton(
                        child: Text(
                          'Save changes & upload',
                          style: TextStyle(fontSize: 18, fontFamily: 'Raleway'),
                        ),
                        color: Color.fromRGBO(99, 154, 103, 1),
                        textColor: Colors.white,
                        onPressed: _saveForm,
                      )
                    ],
                  )),
            ),
    );
  }
}
