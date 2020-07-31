import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/core/database/database.dart';

class AddCatagory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Aggiungi categorie';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  GlobalKey<FormBuilderState> _fbKey;
  File _file;
  @override
  void initState() {
    super.initState();
    _file = null;
    _fbKey = GlobalKey<FormBuilderState>();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              initialValue: {},
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  FormBuilderTextField(
                    maxLines: 1,
                    attribute: "name",
                    decoration: InputDecoration(labelText: "Nome categorie "),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            MaterialButton(
              color: _file == null ? Colors.redAccent : Colors.greenAccent[200],
              child: Text("sceglie immagine",
                  style: TextStyle(color: Colors.white)),
              onPressed: () async {
                _file = await FilePicker.getFile(type: FileType.image);
                setState(() {});
              },
            ),
            SizedBox(height: 20),
            MaterialButton(
              color: Colors.redAccent,
              child: Text("Aggiungi", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (_fbKey.currentState.saveAndValidate()) {
                  if (_file != null) {
                    String name = _fbKey.currentState.value['name'];
                    Fluttertoast.showToast(
                        msg: ' Please Wait ',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    await Database.setCategories(context, name, _file);
                  } else {
                    Fluttertoast.showToast(
                        msg: ' sceglie immagine ',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                }
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
}
