import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyfin/commons/socket_helper.dart';
import 'package:easyfin/entity/User.dart';

import '../entity/accounts.dart';

class SplashScreen extends StatefulWidget {
  final Future<FirebaseApp> initialization;
  const SplashScreen({super.key, required this.initialization});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String status = "connecting to socket";

  @override
  void initState() {
    super.initState();
    widget.initialization.then((_) async => {
      await SocketManager.shared.initSocket(),
      setState(() {
        status = "connected";
      }),
      if (FirebaseAuth.instance.currentUser != null) {
        SocketManager.shared.socket?.once("getUser", (data) {
          user.customerID = data["customerID"];
          user.accounts.clear();
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
            ));
          };
          Navigator.pushReplacementNamed(context, '/gate');
        }),
        SocketManager.shared.socket?.emit("getUser", FirebaseAuth.instance.currentUser?.uid),
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, '/gate');
        }),
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(status),
              const SizedBox(height: 20,),
              const Icon(Iconsax.strongbox_2, color: Color.fromRGBO(52, 90, 251, 1), size: 60,),
              const Text(
                "EasyFin",
                style: TextStyle(fontFamily: "Poppins", fontSize: 40, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              )
            ]),
        ),
      ),
    );
  }
}