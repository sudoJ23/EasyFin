import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easyfin/commons/socket_helper.dart';
import 'package:easyfin/entity/Accounts.dart';
import 'package:easyfin/entity/User.dart';

class AccountDetail extends StatefulWidget {
  const AccountDetail({super.key});

  @override
  State<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  Accounts account = Accounts("Tes", "", "", 0, "", "", "", "", "");
  String currentState = "";
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 0
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        account = ModalRoute.of(context)!.settings.arguments as Accounts;
      });
      print(account.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atur Rekening"),
        leading: BackButton(onPressed: () => Navigator.pop(context, "renamed|${stringToBase64.encode(_pinController.text)}|${_namaController.text}"),),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, "renamed|${stringToBase64.encode(_pinController.text)}|${_namaController.text}");
          return false;
        },
        child: Column(
          children: [
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
                  const Row(
                    children: [
                      Text(
                        "Saldo",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontSize: 16
                        ),
                       ),
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
                          currencyFormatter.format(account.balance),
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
                                  account.name,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                ),
                                Text(
                                  account.pancard,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _namaController.text = account.name;
                                    Codec<String, String> stringToBase64 = utf8.fuse(base64);
                                    String decoded = stringToBase64.decode(account.pin);
                                    _pinController.text = decoded;
                                    showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                        "Ubah nama rekening",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16
                                        ),
                                      ),
                                      content: Container(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            TextField(
                                              decoration: const InputDecoration(
                                                label: Text("Nama rekening")
                                              ),
                                              controller: _namaController,
                                            ),
                                            TextField(
                                              obscureText: true,
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                label: Text("Pin")
                                              ),
                                              controller: _pinController,
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            SocketManager.shared.socket?.once("updateAccountName", (data) {
                                              if (data["status"] == "success") {
                                                SocketManager.shared.socket?.emit("getUser", user.uid);
                                                Navigator.pop(context, "renamed");
                                              }
                                            });
                                            SocketManager.shared.socket?.emit("updateAccountName", {'id': account.id, 'name': _namaController.text, 'pin': stringToBase64.encode(_pinController.text)});
                                          },
                                          child: const Text("Simpan"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Batal"),
                                        )
                                      ],
                                    ),
                                  ).then((value) {
                                    if (value != null) {
                                      if (value == "renamed") {
                                        setState(() {
                                          account.name = _namaController.text;
                                        });
                                      }
                                    }
                                  });},
                                  child: const Text(
                                    "Ubah",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700
                                    ),
                                  )
                                ),
                                TextButton(
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                        "Apakah anda yakin?",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16
                                        ),
                                      ),
                                      content: Text(
                                        "Apakah anda yakin ingin menghapus rekening ${account.name}. Saldo anda akan hilang"
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            SocketManager.shared.socket?.once("deleteAccount", (data) {
                                              if (data["status"] == "success") {
                                                currentState = "deleted";
                                                SocketManager.shared.socket?.emit("getUser", user.uid);
                                                Navigator.pop(context, "deleted");
                                              }
                                            });
                                            SocketManager.shared.socket?.emit("deleteAccount", account.id);
                                          },
                                          child: const Text("Hapus"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Batal"),
                                        )
                                      ],
                                    ),
                                  ),
                                  child: const Text(
                                    "Hapus",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.red,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700
                                    ),
                                  )
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
