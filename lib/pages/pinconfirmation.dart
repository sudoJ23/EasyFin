import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyfin/commons/socket_helper.dart';
import 'package:easyfin/entity/accounts.dart';
import 'package:easyfin/entity/Transfer.dart';
import 'package:easyfin/entity/User.dart';
import 'package:easyfin/entity/receiptresponse.dart';

class PinConfirmationPage extends StatefulWidget {
  const PinConfirmationPage({super.key});

  @override
  State<PinConfirmationPage> createState() => _PinConfirmationPageState();
}

class _PinConfirmationPageState extends State<PinConfirmationPage> {

  final Container _inactivePin = Container(
    height: 15,
    width: 15,
    margin: const EdgeInsets.all(10),
    decoration: ShapeDecoration(
      shape: const CircleBorder(side: BorderSide.none),
      color: Colors.grey.shade300
    ),
  );

  bool pinIncorrect = false;

  final Container _activePin = Container(
    height: 15,
    width: 15,
    margin: const EdgeInsets.all(10),
    decoration: ShapeDecoration(
      shape: const CircleBorder(side: BorderSide.none),
      color: Colors.grey.shade800
    ),
  );

  final List<Container> _pins = [];
  final List<Container> _inCorrectPins = [
    Container(
      height: 15,
      width: 15,
      margin: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        shape: const CircleBorder(side: BorderSide.none),
        color: Colors.red.shade400
      ),
    ),
    Container(
      height: 15,
      width: 15,
      margin: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        shape: const CircleBorder(side: BorderSide.none),
        color: Colors.red.shade400
      ),
    ),
    Container(
      height: 15,
      width: 15,
      margin: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        shape: const CircleBorder(side: BorderSide.none),
        color: Colors.red.shade400
      ),
    ),
    Container(
      height: 15,
      width: 15,
      margin: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        shape: const CircleBorder(side: BorderSide.none),
        color: Colors.red.shade400
      ),
    ),
    Container(
      height: 15,
      width: 15,
      margin: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        shape: const CircleBorder(side: BorderSide.none),
        color: Colors.red.shade400
      ),
    ),
    Container(
      height: 15,
      width: 15,
      margin: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        shape: const CircleBorder(side: BorderSide.none),
        color: Colors.red.shade400
      ),
    ),
  ];

  String pin = "";

  @override
  void initState() {
    if (kDebugMode) {
      print(Transfer.amount);
      print(Transfer.note);
      print(Transfer.receiverName);
      print(Transfer.receiverPancard);
      print(Transfer.accountId);
    }
    setState(() {  
      for (var i = 0; i < 6; i++) {
        _pins.add(_inactivePin);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            leading: BackButton(color: Colors.grey.shade800),
          ),
          SliverList(delegate: SliverChildListDelegate([
            const SizedBox(height: 20,),
            Column(
              children: [
                Text(
                  "Masukkan PIN",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: pinIncorrect ? Colors.red : Colors.grey.shade900
                  ),
                )
              ],
            ),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: pinIncorrect ? _inCorrectPins : _pins,
            )
          ])),
          SliverFillRemaining(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          checkPin(1);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          margin: const EdgeInsets.all(20),
                          child: const Center(
                            child: Text(
                              "1",
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkPin(2);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          margin: const EdgeInsets.all(20),
                          child: const Center(
                            child: Text(
                              "2",
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkPin(3);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          margin: const EdgeInsets.all(20),
                          child: const Center(
                            child: Text(
                              "3",
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          checkPin(4);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          margin: const EdgeInsets.all(20),
                          child: const Center(
                            child: Text(
                              "4",
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkPin(5);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          margin: const EdgeInsets.all(20),
                          child: const Center(
                            child: Text(
                              "5",
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkPin(6);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          margin: const EdgeInsets.all(20),
                          child: const Center(
                            child: Text(
                              "6",
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          checkPin(7);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          margin: const EdgeInsets.all(20),
                          child: const Center(
                            child: Text(
                              "7",
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkPin(8);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          margin: const EdgeInsets.all(20),
                          child: const Center(
                            child: Text(
                              "8",
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkPin(9);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          margin: const EdgeInsets.all(20),
                          child: const Center(
                            child: Text(
                              "9",
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(20),
                        child: const Center(
                          child: Text(
                            "Lupa?",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins'
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkPin(0);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          margin: const EdgeInsets.all(20),
                          child: const Center(
                            child: Text(
                              "0",
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (pin.isNotEmpty) {
                              pin = pin.substring(0, pin.length - 1);
                              _pins[pin.length] = _inactivePin;
                            }
                          });
                        },
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(20),
                          child: const Center(
                            child: Icon(Iconsax.arrow_left_1)
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }

  void checkPin(num number) {
    if (pin.length < 6) {
      setState(() {
        _pins[pin.length] = _activePin;
        pin += number.toString();
      });

      if (pin.length == 6) {
        setState(() {
          String userpin = utf8.decode(base64Decode(user.selectedAccount.pin));
          if (userpin == pin) {
            var request = {
              "transactionType": 'transfer',
              "senderAccountID": user.selectedAccount.id,
              "receiverAccountID": Transfer.accountId,
              "amount": Transfer.amount,
              "transactionMedium": "ebanking",
              "note": Transfer.note
            };
            SocketManager.shared.socket?.emit("transfer", request);
            SocketManager.shared.socket?.once("transfer", (data) => {
              if (data["message"] == "success") {
                SocketManager.shared.socket?.emit("getTransactions", user.customerID),
                SocketManager.shared.socket?.emit("getUser", user.uid),
                for (Accounts account in user.accounts) {
                  if (account.id == user.selectedAccount.id) {
                    account.balance -= Transfer.amount,
                    user.selectedAccount = account
                  }
                },
                Navigator.pushReplacementNamed(context, '/transfer/success', arguments: ReceiptResponse(data["response"]["timestamp"], data["response"]["amount"]))
              }
            });
          } else {
            pinIncorrect = true;
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                pinIncorrect = false;
                pin = "";
                _pins.clear();
                for (var i = 0; i < 6; i++) {
                  _pins.add(_inactivePin);
                }
              });
            });
            if (kDebugMode) {
              print("Incorrect");
            }
          }
        });
      }
      if (kDebugMode) {
        print(pin);
      }
    }
  }
}