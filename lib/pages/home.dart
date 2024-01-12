import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:easyfin/entity/accounts.dart';
import 'package:easyfin/entity/User.dart';
import 'package:easyfin/commons/socket_helper.dart';
import 'package:easyfin/entity/transaction.dart';
import 'package:easyfin/entity/transactions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  Color mainColor = const Color.fromRGBO(52, 90, 251, 1);
  String _name = "";
  User? uid = FirebaseAuth.instance.currentUser;
  Accounts _selectedAccount = user.selectedAccount;
  String _timeOfDay = "Pagi";
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 0
  );
  String balanceDisplay = "";
  bool showBalance = true;

  String determineTimeOfDay() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    if (currentHour >= 6 && currentHour < 12) {
      return 'Pagi'; // 6:00 - 11:59
    } else if (currentHour >= 12 && currentHour < 17) {
      return 'Siang'; // 12:00 - 16:59
    } else if (currentHour >= 17 && currentHour < 20) {
      return 'Sore'; // 17:00 - 19:59
    } else {
      return 'Malam'; // 20:00 - 5:59
    }
  }

  @override
  void initState() {
    SocketManager.shared.socket?.emit("getUser", FirebaseAuth.instance.currentUser?.uid);
    SocketManager.shared.socket?.on("getTransactions", (data) {
      Transactions.list.clear();
      for (var i = 0; i < data.length; i++) {
        Transactions.list.add(Transaction(
          data[i]["id"],
          data[i]["transactionType"],
          data[i]["sender"],
          data[i]["receiver"],
          data[i]["dateIssued"],
          int.parse(data[i]["amount"]),
          data[i]["direction"]
        ));
      }
    });
    SocketManager.shared.socket?.on("getUser", (data) => {
      user.uid = data["id"],
      user.customerID = data["customerID"],
      user.email = data["email"],
      user.name = data["name"],
      user.firstName = data["firstName"],
      user.lastName = data["lastName"],
      user.accounts.clear(),
      for (var i = 0; i < data["accounts"].length; i++) {
        user.accounts.add(Accounts(
          data["accounts"][i]["id"],
          data["accounts"][i]["name"],
          data["accounts"][i]["customer_id"],
          int.parse(data["accounts"][i]["balance"]),
          data["accounts"][i]["account_status"],
          data["accounts"][i]["account_type"],
          data["accounts"][i]["currency"],
          data["accounts"][i]["pancard_no"],
          data["accounts"][i]["pin"]
        )),
      },
      user.selectedAccount = user.accounts[0],
      SocketManager.shared.socket?.emit("getTransactions", user.customerID),
      if (mounted) {
        setState(() {
          if (showBalance) {
            balanceDisplay = currencyFormatter.format(_selectedAccount.balance);
          } else {
            balanceDisplay = "*******";
          }
          _name = user.name;
          _selectedAccount = user.selectedAccount;
          if (showBalance) {
            balanceDisplay = currencyFormatter.format(_selectedAccount.balance);
          } else {
            balanceDisplay = "*******";
          }
        })
      }
    });
    _scrollController.addListener(_listenToScrollChange);
    _timeOfDay = determineTimeOfDay();
    super.initState();
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 100.0) {
      setState(() {
      });
    } else {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: true,
            stretch: true,
            toolbarHeight: 80,
            backgroundColor: Colors.grey.shade100,
            title: Container(
              padding: const EdgeInsets.only(left: 10, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat $_timeOfDay",
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    _name,
                    style: const TextStyle(
                      color: Color.fromRGBO(52, 90, 251, 1),
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.normal
                    ),
                  )
                ],
              ),
            ),
            centerTitle: false,
          ),
          SliverList(delegate: SliverChildListDelegate([
            Container(
              decoration: const ShapeDecoration(
                color: Color.fromRGBO(52, 90, 251, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10)
                  )
                )
              ),
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                     const Text(
                      "Saldo",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontSize: 16
                      ),
                     ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (showBalance) {
                              balanceDisplay = "*******";
                              showBalance = false;
                            } else {
                              balanceDisplay = currencyFormatter.format(_selectedAccount.balance);
                              showBalance = true;
                            }
                          });
                        },
                        icon: const Icon(Iconsax.eye),
                        iconSize: 18,
                        color: Colors.white,
                      )
                    ],
                  ),
                  FadeInLeft(
                    duration: const Duration(milliseconds: 600),
                    child: Row(
                      children: [
                        const Text(
                          "Rp  ",
                          style: TextStyle(
                            color: Color.fromRGBO(216, 216, 216, 1),
                            fontFamily: 'Poppins',
                            fontSize: 32
                          ),
                        ),
                        Text(
                          balanceDisplay,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 32
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.selectedAccount.name,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                ),
                                Text(
                                  user.selectedAccount.pancard,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700
                                  ),
                                )
                              ],
                            ),
                            TextButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    "Pilih rekening",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  content: SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      itemCount: user.accounts.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (kDebugMode) {
                                              print("Kartu yang ini ${user.accounts[index].balance}");
                                              print(user.accounts[index].pancard);
                                            }
                                            setState(() {
                                              _selectedAccount = user.accounts[index];
                                              user.selectedAccount = user.accounts[index];
                                              if (showBalance) {
                                                balanceDisplay = currencyFormatter.format(_selectedAccount.balance);
                                              } else {
                                                balanceDisplay = "*******";
                                              }
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius: BorderRadius.circular(5)
                                            ),
                                            margin: const EdgeInsets.only(
                                              left: 2,
                                              right: 2,
                                              top: 10,
                                            ),
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              top: 10
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user.accounts[index].name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w300
                                                  ),
                                                ),
                                                Text(
                                                  user.accounts[index].pancard,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w300
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("Batal"),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              child: const Text(
                                "Ubah",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700
                                ),
                              )
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ])),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.only(top: 20),
                height: 115,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/contact');
                              },
                              icon: const Icon(Iconsax.export_1, color: Colors.white, size: 25),
                            )
                          ),
                          const SizedBox(height: 10,),
                          Text("Transfer", style: TextStyle(color: Colors.grey.shade800, fontSize: 12),)
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: IconButton(
                              onPressed:() {
                                Navigator.pushNamed(context, '/qr');
                              },
                              icon: const Icon(Iconsax.scan_barcode, color: Colors.white, size: 25)
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text("Share", style: TextStyle(color: Colors.grey.shade800, fontSize: 12),)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ])
          ),
          SliverFillRemaining(
            fillOverscroll: true,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Transaksi Terakhir', style: TextStyle(color: Colors.grey.shade800, fontSize: 14, fontWeight: FontWeight.w600),),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/history');
                        },
                        child: Text(
                          'Selengkapnya',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ),
                    ]
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: Transactions.list.length,
                      itemBuilder: (context, index) {
                        return FadeInDown(
                          duration: const Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: () {
                              if (kDebugMode) {
                                print(Transactions.list[index].amount);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(Transactions.list[index].transactionType.toUpperCase(), style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w500, fontSize: 14),),
                                          const SizedBox(height: 2,),
                                          Text(Transactions.list[index].receiver, style: TextStyle(color: Colors.grey.shade700, fontSize: 14),),
                                          const SizedBox(height: 2,),
                                          Text(Transactions.list[index].dateIssued, style: TextStyle(color: Colors.grey.shade500, fontSize: 12),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Transactions.list[index].direction == "in" ? currencyFormatter.format(Transactions.list[index].amount) : "-${currencyFormatter.format(Transactions.list[index].amount)}",
                                        style: TextStyle(
                                          color: Transactions.list[index].direction == "in" ? Colors.green : Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700
                                        ),
                                      ),
                                      Icon(
                                        Transactions.list[index].direction == "in" ? Iconsax.arrow_down : Iconsax.arrow_up_3,
                                        color: Transactions.list[index].direction == "in" ? Colors.green : Colors.red,
                                        size: 25
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}