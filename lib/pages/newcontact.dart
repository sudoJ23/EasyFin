import 'package:flutter/material.dart';
import 'package:easyfin/commons/socket_helper.dart';
import 'package:easyfin/entity/User.dart';

import '../entity/Contact.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({super.key});

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {

  final TextEditingController _emailController = TextEditingController();
  Contact foundContact = Contact("", "", "", "", "");

  void showMessage(String title, String content, BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Text(content),
          title: Text(title),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Tutup"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Tambah kontak', style: TextStyle(color: Colors.black),),
        leading: const BackButton(color: Colors.black),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(delegate: SliverChildListDelegate([
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tambahkan kontak menggunakan email",
                    style: TextStyle(
                      fontFamily: 'Poppins'
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: const Color.fromARGB(255, 52, 90, 251),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          style: TextStyle(
                            color: Colors.grey.shade100,
                            fontFamily: 'Poppins'
                          ),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade100)
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade100)
                            ),
                            labelText: "Email",
                            labelStyle: TextStyle(
                              color: Colors.grey.shade300,
                              fontFamily: 'Poppins'
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 40,),
                        GestureDetector(
                          onTap: () {
                            if (_emailController.text != "") {
                              print("Searching ${_emailController.text}");
                              SocketManager.shared.socket?.once("findEmail", (data) => {
                                // data["message"] == "found" ? data["data"][0]["name"] : "Tidak ditemukan"
                                if (data["message"] == "found") {
                                  foundContact = Contact(data["data"][0]["id"], data["data"][0]["firstName"], data["data"][0]["lastName"], data["data"][0]["email"], data["data"][0]["customerID"])
                                },
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  useSafeArea: true,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  builder: (context) {
                                    return Container(
                                      height: 160,
                                      padding: const EdgeInsets.all(20),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            data["message"] == "found" ? data["data"][0]["name"] : "Tidak ditemukan",
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700
                                            ),
                                          ),
                                          Text(
                                            _emailController.text,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          // Container(
                                          //   child: ,
                                          // ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (data["message"] == "found") {
                                                    SocketManager.shared.socket?.emit("addContact", {"ownerID": user.uid, "userID": foundContact.id});
                                                    SocketManager.shared.socket?.once("addContact", (result) {
                                                      if (result["status"] == "failed") {
                                                        if (result["message"] == "cannot added yourself") {
                                                          Navigator.pop(context, "cannot added yourself");
                                                        } else if (result["message"] == "contact has been saved") {
                                                          Navigator.pop(context, "contact has been saved");
                                                        }
                                                      } else if (result["status"] == "success") {
                                                        Navigator.pop(context, "successfully added contact");
                                                      }
                                                    });
                                                  } else {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: ShapeDecoration(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                    color: const Color.fromARGB(255, 52, 90, 251)
                                                  ),
                                                  child: Text(
                                                    data["message"] == "found" ? "Tambah kontak" : "Tutup",
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.grey.shade100
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ).then((value) {
                                  if (value != null) {
                                    if (value == "successfully added contact") {
                                      Navigator.pop(context, "new contact");
                                    }
                                    else if (value == "cannot added yourself") {
                                      showMessage("Peringatan", "Tidak dapat menambahkan diri anda sendiri", context);
                                    } else if (value == "contact has been saved") {
                                      showMessage("Peringatan", "Kontak telah ada", context);
                                    }
                                    // Navigator.pop(context, "new contact");
                                  }
                                })
                              });
                              SocketManager.shared.socket?.emit("findEmail", _emailController.text);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              color: Colors.grey.shade200
                            ),
                            child: Center(
                              child: Text(
                                "Cari kontak",
                                style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600
                                ),
                              )
                            ),
                          )
                        )
                      ],
                    )
                  ),
                ],
              ),
            )
          ]))
        ],
      )
    );
  }
}
