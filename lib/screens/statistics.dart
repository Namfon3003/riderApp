import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/Order_models.dart';
import '../models/api.dart';
import '../models/transaction_model.dart';
import '../models/wallet_model.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<TransactionRider> transactionRider = [];
  Wallet riderWallet = Wallet(walletID: "", riderID: "", balance: 0);
  double totalIncomeAmount = 0;
  double totalWithdrawnAmount = 0;
  List<OrderModel> listOrder = [];
  DateTime date = DateTime.now();

  int countError = 0;
  int countCom = 0;

  OrderModel order = OrderModel(
      orderID: "",
      addressID: " ",
      payID: " ",
      cartID: " ",
      storeID: "",
      riderID: " ",
      date: " ",
      time: " ",
      status: 0,
      userID: " ");

  @override
  void initState() {
    getData();
    getOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromARGB(255, 120, 56, 192), Colors.white]),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image(
                        width: 50,
                        height: 50,
                        image: AssetImage("assets/images/graph.png")),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "สถิติของคุณ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                  width: double.infinity,
                  height: 735,
                  // color: Colors.white,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(100),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "รายงานสถิติ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 59, 42, 78),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));

                            if (newDate == null) return;
                            setState(() {
                              date = newDate;
                            });
                            getData();
                            getOrder();
                          },
                          child: Row(
                            children: [
                              Image(
                                  width: 40,
                                  height: 40,
                                  image:
                                      AssetImage("assets/images/calendar.png")),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'วันที่ ${date.day}/${date.month}/${date.year}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 73, 72, 73),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 350,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 243, 242, 242),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 3.0, // soften the shadow
                                  spreadRadius: 1.0, //extend the shadow
                                  offset: Offset(
                                    5.0, // Move to right 5  horizontally
                                    5.0, // Move to bottom 5 Vertically
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(100),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "รายได้ทั้งหมด",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 59, 42, 78),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      totalIncomeAmount.toString(),
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 5, 85, 38),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 350,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 207, 241, 202),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 3.0, // soften the shadow
                                  spreadRadius: 1.0, //extend the shadow
                                  offset: Offset(
                                    5.0, // Move to right 5  horizontally
                                    5.0, // Move to bottom 5 Vertically
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(100),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "ออเดอร์ที่สำเร็จ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 3, 71, 20),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      countCom.toString(),
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 5, 85, 38),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 350,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 243, 218, 218),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 3.0, // soften the shadow
                                  spreadRadius: 1.0, //extend the shadow
                                  offset: Offset(
                                    5.0, // Move to right 5  horizontally
                                    5.0, // Move to bottom 5 Vertically
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(100),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "ออเดอร์ที่ถูกยกเลิก",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 167, 3, 16),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      countError.toString(),
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 167, 3, 16),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  String path = Api().path;
  getData() async {
    await Hive.openBox('id');
    var idRider = await Hive.box('id');
    String riderID = idRider.get(0);

    var url = Uri.parse("$path/WalletRider/Search?keyword=$riderID");
    var response = await http.get(url);
    List<Wallet> listRiderWallet = walletFromJson(response.body);
    riderWallet = listRiderWallet[0];

    var url2 = Uri.parse(
        "$path/TransactionRider/Search?keyword=${riderWallet.walletID}");
    var response2 = await http.get(url2);
    transactionRider = transactionRiderFromJson(response2.body);

    totalWithdrawnAmount = 0;
    totalIncomeAmount = 0;
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    String dateCheck = formatter.format(date);
    for (var t in transactionRider) {
      if (dateCheck == t.Date.split(" ")[0]) {
        if (t.Trans_Name == "เงินเข้า") {
          totalIncomeAmount += t.Amount;
        }
      }
    }

    setState(() {
      riderWallet;
      transactionRider;
      totalWithdrawnAmount;
      totalIncomeAmount;
    });
  }

  getOrder() async {
    await Hive.openBox('id');
    var idRider = await Hive.box('id');
    String riderID2 = idRider.get(0);
    var url = Uri.parse(path + "/Order");

    var response = await http.get(url);
    List<OrderModel> listOrderTemp = orderModelFromJson(response.body);

    countError = 0;
    countCom = 0;
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    String dateCheck = formatter.format(date);
    print(dateCheck);
    for (var item in listOrderTemp) {
      // ignore: unrelated_type_equality_checks
      if (item.riderID == riderID2 && item.riderID != "") {
        var newDate = item.date.split(" ")[0].split("/");
        String tDate = newDate[0] +
            "/" +
            newDate[1] +
            "/" +
            (convertBEtoAD(int.parse(newDate[2]))).toString();
        if (item.date.split(" ")[0] == dateCheck || tDate == dateCheck) {
          if (item.status == 4) {
            countError++;
          } else if (item.status == 3) {
            countCom++;
          }
        }
      }
    }

    setState(() {
      countError;
      countCom;
    });
  }

  convertBEtoAD(int be) {
    return be - 543;
  }
}
