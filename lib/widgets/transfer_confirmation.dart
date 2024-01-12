import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:easyfin/entity/Transfer.dart';
import 'package:easyfin/entity/User.dart';

class TransferConfirmation extends StatefulWidget {
  const TransferConfirmation(
      {super.key,
      required this.nominal,
      required this.receiverName,
      required this.receiverPancard});
  final num nominal;
  final String receiverName;
  final String receiverPancard;

  @override
  State<TransferConfirmation> createState() => TransferConfirmationState();
}

class TransferConfirmationState extends State<TransferConfirmation> {
  NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Transfer.note.isNotEmpty ? 480 : 450,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Konfirmasi Transfer",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              IconButton(
                icon: const Icon(Iconsax.close_circle),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.receiverName.toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                widget.receiverPancard,
                style: const TextStyle(fontFamily: 'Poppins'),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                    bottom: BorderSide(color: Colors.grey.shade300))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Nominal Transfer",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Text(
                      "Rp ${currencyFormatter.format(widget.nominal)}",
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Transfer.note.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 15),
                  padding: const EdgeInsets.only(top: 0, bottom: 15),
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          bottom: BorderSide(color: Colors.grey.shade300))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(Transfer.note)],
                  ),
                )
              : Container(),
          const Text(
            "Rekening Sumber",
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.only(top: 10, right: 0, left: 0),
            padding: const EdgeInsets.all(15),
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey.shade300))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user.selectedAccount.name} - ${user.selectedAccount.pancard}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 18),
                ),
                Text(
                  "Rp ${currencyFormatter.format(user.selectedAccount.balance)}",
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/transfer/confirmation');
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20),
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: const Color.fromRGBO(52, 90, 251, 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Lanjut Transfer",
                    style: TextStyle(
                        color: Colors.grey.shade100,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  Row(
                    children: [
                      Text(
                        "Rp ${currencyFormatter.format(widget.nominal)}",
                        style: TextStyle(
                            color: Colors.grey.shade100,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Iconsax.arrow_right_1,
                        color: Colors.grey.shade100,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
