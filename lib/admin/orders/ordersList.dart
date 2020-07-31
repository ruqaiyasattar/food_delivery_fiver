import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/admin/orders/style.dart';
import 'package:food_delivery_app/core/database/database.dart';

class MyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Ordini';
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
  List<Widget> extrasList(Map quan, Map data) {
    List<Widget> lines = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i] != null) {
        lines.add(Row(
          children: <Widget>[
            Text("Nome of Item:"),
            Spacer(),
            Text(data[i]["name"]),
          ],
        ));
        lines.add(Row(
          children: <Widget>[
            Text("Caregorie:"),
            Spacer(),
            Text(data[i]["category"]),
          ],
        ));
        lines.add(Row(
          children: <Widget>[
            Text("Descrizione: "),
            Text(data[i]["description"]),
          ],
        ));
        Map m = data[i]["extras"];
        if (m != null) {
          lines.add(Row(
            children: <Widget>[
              Text("Personalizzazione: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Spacer()
            ],
          ));
          for (String j in m.keys) {
            lines.add(Row(
              children: <Widget>[
                Text("$j: "),
                Spacer(),
                Text(m[j].toString()),
              ],
            ));
          }
        }
      } else {
        lines.add(Row(
          children: <Widget>[
            Text("__Prodotti not exit anymore"),
            Spacer(),
          ],
        ));
      }
      lines.add(MySeparator(
        color: Colors.grey,
      ));
    }
    return lines;
  }

  List<Widget> itemsList(Map data) {
    List<Widget> lines = [];
    data.forEach((k, v) => () {
          lines.add(
            Text("Item",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          );
          Map optional = v["optional"];
          lines.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Caregorie"),
              Text(v["catagory"]),
            ],
          ));
          lines.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("sottocategorie"),
              Text(v["subCatagory"]),
            ],
          ));
          lines.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Quantità"),
              Text(v["quantity"].toString()),
            ],
          ));
          lines.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Speciale Requisiti"),
              Text(v["requirments"] == ""
                  ? "No Special Requirment"
                  : v["requirments"]),
            ],
          ));
          lines.add(
            Text("Requisiti",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          );
          optional.forEach((sk, sv) => () {
                if (sv["null"] == "3") {
                } else if (sv.length > 0) {
                  List list = sv.values.toList();
                  lines.add(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(sk),
                        Text(list[0] == "0"
                            ? "Left Topping"
                            : list[0] == "1"
                                ? "Right Topping"
                                : list[0] == "2" ? "Full Topping" : ""),
                      ],
                    ),
                  );
                }
              }());
          lines.add(SizedBox(height: 8));
          lines.add(MySeparator(
            color: Colors.grey,
          ));
          lines.add(SizedBox(height: 8));
        }());
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Map>>(
      future: Database.getOrdersDetailsList(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, Map>> snapshot) {
        if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                height: 45,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
                ),
              );
            default:
              Map<String, Map> snap = snapshot.data;
              List list = new List();
              for (Map m in snap.values) list.add(m);
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 13, 0, 13),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
                      child: Card(
                        margin: EdgeInsets.all(1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.0)),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text("Nome :"),
                                  ),
                                  Text(
                                      list[index]["user"]["name"] ?? "Notgiven")
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text("email "),
                                  ),
                                  Text(list[index]["user"]["email"] ??
                                      "Notgiven")
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text("Indirizzo "),
                                  ),
                                  Text(list[index]["user"]["address"] ??
                                      "Notgiven")
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text("società "),
                                  ),
                                  Text(list[index]["user"]["society"] ??
                                      "Notgiven")
                                ],
                              ),
                              SizedBox(height: 5),
                              MySeparator(
                                color: Colors.grey,
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Text("Lista ordini:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Spacer()
                                ],
                              ),
                              SizedBox(height: 5),
                              Column(
                                children: extrasList(list[index]["quantities"],
                                    list[index]["productList"]),
                              ),
                              MySeparator(
                                color: Colors.grey,
                              ),
                              SizedBox(height: 5),
                              list[index]["status"]["status"] == "0"
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          InkWell(
                                            child: Text(
                                              "Accetta",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onTap: () {
                                              Firestore.instance
                                                  .collection("orders")
                                                  .document(list[index]["user"]
                                                      ["uId"])
                                                  .collection("requests")
                                                  .document(list[index]
                                                      ["orderId"]["oId"])
                                                  .updateData({"status": "1"});
                                              setState(() {});
                                            },
                                          ),
                                          InkWell(
                                            child: Text(
                                              "Respingi",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onTap: () {
                                              Firestore.instance
                                                  .collection("orders")
                                                  .document(list[index]["user"]
                                                      ["uId"])
                                                  .collection("requests")
                                                  .document(list[index]
                                                      ["orderId"]["oId"])
                                                  .updateData({"status": "2"});
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : list[index]["status"]["status"] == "1"
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              InkWell(
                                                child: Text(
                                                  "Completato",
                                                  style: TextStyle(
                                                      color: Colors.greenAccent,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onTap: () {
                                                  Firestore.instance
                                                      .collection("orders")
                                                      .document(list[index]
                                                          ["user"]["uId"])
                                                      .collection("requests")
                                                      .document(list[index]
                                                          ["orderId"]["oId"])
                                                      .updateData(
                                                          {"status": "3"});
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      : list[index]["status"]["status"] == "3"
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  InkWell(
                                                    child: Text(
                                                      "Cancella",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onTap: () {
                                                      Firestore.instance
                                                          .collection("orders")
                                                          .document(list[index]
                                                              ["user"]["uId"])
                                                          .collection(
                                                              "requests")
                                                          .document(list[index]
                                                                  ["orderId"]
                                                              ["oId"])
                                                          .delete();
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  InkWell(
                                                      child: Text(
                                                        "Deleat",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onTap: () {
                                                        Firestore.instance
                                                            .collection(
                                                                "Orders")
                                                            .document(
                                                                list[index]
                                                                    .documentID)
                                                            .delete();

                                                        setState(() {});
                                                      }),
                                                ],
                                              ),
                                            )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
          }
        }
      },
    );
  }
}
