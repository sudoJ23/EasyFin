import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easyfin/commons/socket_helper.dart';
import 'package:easyfin/entity/Transfer.dart';
import 'package:easyfin/entity/User.dart';
import 'package:easyfin/entity/receiptresponse.dart';

class Receipt extends StatefulWidget {
  const Receipt({super.key});

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  String senderName = "${user.firstName} ${user.lastName}";
  String senderPan = user.selectedAccount.pancard;
  ReceiptResponse response = ReceiptResponse("", 0);

  NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This will be called after the first build
      setState(() {
        response =
            ModalRoute.of(context)!.settings.arguments as ReceiptResponse;
        print(response.amount);
        print(response.timestamp);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SocketManager.shared.socket?.emit("getUser", user.uid);
          // Navigator.
          Navigator.popUntil(context, (route) => route.isFirst);
          return false;
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverSafeArea(
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transfer Rupiah",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Transfer Berhasil!",
                        style: TextStyle(
                            color: Colors.grey.shade900,
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        // "02 Jan 2024 • 01:44:06 WIB",
                        response.timestamp,
                        style: TextStyle(color: Colors.grey.shade500),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Penerima",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Poppins',
                            fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        Transfer.receiverName.length <= 20
                            ? Transfer.receiverName.toUpperCase()
                            : Transfer.receiverName
                                .substring(0, 20)
                                .toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        Transfer.receiverPancard,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Detail Transaksi",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nominal Transfer",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                fontSize: 15),
                          ),
                          Text(
                            "Rp ${currencyFormatter.format(response.amount)}",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                fontSize: 15),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15, bottom: 15),
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Colors.grey.shade900),
                                bottom:
                                    BorderSide(color: Colors.grey.shade900))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Transaksi",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  fontSize: 15),
                            ),
                            Text(
                              "Rp ${currencyFormatter.format(response.amount)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Rekening Sumber",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        senderName.length <= 20
                            ? senderName.toUpperCase()
                            : senderName.substring(0, 20).toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "••••••${senderPan.substring(6, 10)}",
                        style: TextStyle(
                            color: Colors.grey.shade700, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Keterangan Transaksi",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        Transfer.note,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                )
              ])))
            ],
          ),
        ));
  }
}
