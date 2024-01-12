import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../entity/transaction.dart';
import '../entity/transactions.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 0
  );

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              "Riwayat Transaksi",
              style: TextStyle(color: Colors.grey.shade900),
            ),
            backgroundColor: Colors.transparent,
            leading: const BackButton(color: Colors.black),
          ),
          // SliverSafeArea(
          //   bottom: true,
          //   sliver: SliverList(
          //     delegate: SliverChildListDelegate([
          //       Container(
          //         margin: const EdgeInsets.all(10),
          //         padding: const EdgeInsets.all(10),
          //         child: const Text(
          //           "Transaction History",
          //           style: TextStyle(
          //             fontFamily: 'Poppins',
          //             fontSize: 18,
          //             fontWeight: FontWeight.w500
          //           ),
          //         )
          //       ),
          //     ]),
          //   ),
          // ),
          SliverFillRemaining(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
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
                      margin: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Transactions.list[index].direction == "in" ? Iconsax.arrow_down : Iconsax.arrow_up_3,
                                  color: Transactions.list[index].direction == "in" ? Colors.green : Colors.red,
                                  size: 25
                                )
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
    );
  }
}
