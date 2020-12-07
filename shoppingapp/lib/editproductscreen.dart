import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product.dart';
import './products_provider.dart';

class Editproduct extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<Editproduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var inistate=true;
  var initvalue={
    'title':'',
    'desciption':'',
    'price':'',
    'imageurl':'',
  };
  var isloading=false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(inistate)
      {
        final productid=ModalRoute.of(context).settings.arguments as String;
        if(productid!=null)
          {
            final product=Provider.of<Products>(context).findbyid(productid);
            _editedProduct=product;
            initvalue={
              'title':_editedProduct.title,
              'description':_editedProduct.description,
              'price':_editedProduct.price.toString(),
              //'imageurl':_editedProduct.imageUrl
            };
            _imageUrlController.text=_editedProduct.imageUrl;
          }

      }
    inistate=false;
    super.didChangeDependencies();
  }
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
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

  Future<void> _saveForm() async {
   final isval= _form.currentState.validate();
   if(!isval)
     {
       return;
     }
    _form.currentState.save();
   setState(() {
     isloading=true;
   });

    if(_editedProduct.id!=null)
      {
        await Provider.of<Products>(context,listen: false).updateproduct(_editedProduct.id,_editedProduct);
        setState(() {
          isloading=true;
        });
        Navigator.of(context).pop();
      }else{
      try{
        await Provider.of<Products>(context,listen: false).addproduct(_editedProduct);
      }catch(error){

        await showDialog(context: context,
        builder: (ctx)=>AlertDialog(
          title: Text('An error occured'),
          content:Text('something went wrong'),
            actions: [
              FlatButton(
                child: Text('Okay'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
        ),);
      }finally{
        setState(() {
          isloading=true;
        });
        Navigator.of(context).pop();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: isloading?Center(
        child: CircularProgressIndicator(),
      ):Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: initvalue['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isfav: _editedProduct.isfav,
                  );
                },
                validator: (value)
                {
                  if(value.isEmpty)
                    {
                      return'please provide the value';
                    }
                  return null;
                  },
              ),
              TextFormField(
                initialValue: initvalue['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isfav: _editedProduct.isfav,
                  );
                },
                validator: (value)
                {
                  if(value.isEmpty)
                    {
                      return'please enter value of price';
                    }
                  if(double.tryParse(value)==null)
                    {
                      return'please provide valid number';
                    }
                  if(double.parse(value)<=0){
                     return 'please enter number greater than 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: initvalue['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isfav: _editedProduct.isfav,
                  );
                },
                validator: (value)
                {
                  if(value.isEmpty)
                  {
                    return'please provide the Description';
                  }
                  if(value.length<10)
                    {
                      return'should be greater than 10';
                    }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      //initialValue: initvalue['imageurl'],
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value,
                          id: _editedProduct.id,
                          isfav: _editedProduct.isfav,

                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
