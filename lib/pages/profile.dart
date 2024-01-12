import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyfin/entity/User.dart';

import '../commons/socket_helper.dart';
import '../entity/Accounts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ScrollController _scrollController;
  final User? _user = FirebaseAuth.instance.currentUser;
  String uid = "";
  String displayName = "";
  String name = "Default";
  String email = "";
  String phoneNumber = "";

  @override
  void initState() {
    _scrollController = ScrollController();
    SocketManager.shared.socket?.on(
        "getUser",
        (data) => {
              print("get new data"),
              user.uid = data["id"],
              user.customerID = data["customerID"],
              user.email = data["email"],
              user.name = data["name"],
              user.firstName = data["firstName"],
              user.lastName = data["lastName"],
              user.accounts.clear(),
              for (var i = 0; i < data["accounts"].length; i++)
                {
                  user.accounts.add(Accounts(
                      data["accounts"][i]["id"],
                      data["accounts"][i]["name"],
                      data["accounts"][i]["customer_id"],
                      int.parse(data["accounts"][i]["balance"]),
                      data["accounts"][i]["account_status"],
                      data["accounts"][i]["account_type"],
                      data["accounts"][i]["currency"],
                      data["accounts"][i]["pancard_no"],
                      data["accounts"][i]["pin"])),
                },
              user.selectedAccount = user.accounts[0],
              SocketManager.shared.socket
                  ?.emit("getTransactions", user.customerID),
              setState(() {
                name = user.name;
              })
            });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(controller: _scrollController, slivers: [
        SliverAppBar(
          elevation: 0,
          pinned: true,
          stretch: true,
          // toolbarHeight: 80,
          backgroundColor: Colors.grey.shade100,
          title: Center(
            child: Text(
              "Profile",
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.grey.shade800,
                  fontSize: 16),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 18),
                ),
                Text(
                  user.email,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                )
              ],
            ),
          )
        ])),
        SliverList(
            delegate: SliverChildListDelegate([
          const SizedBox(
            height: 50,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/gate');
              },
              child: Row(
                children: [
                  const Icon(Iconsax.logout_1, size: 24),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Colors.grey.shade300))),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.red.shade600,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/topup')
                    .then((value) => print(value));
              },
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  const Icon(Iconsax.sidebar_top, size: 24),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Colors.grey.shade300))),
                    child: Text(
                      "Top Up",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 41, 140, 216),
                          fontWeight: FontWeight.w500),
                    ),
                  ))
                ],
              ),
            ),
          )
        ]))
      ]),
    );
  }
}
