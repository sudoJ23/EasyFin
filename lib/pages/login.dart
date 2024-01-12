import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallet/commons/socket_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wallet/entity/User.dart';

import 'package:wallet/auth/auth_service.dart';

import '../entity/Accounts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailTextController = TextEditingController();
  late final TextEditingController _passwordTextController = TextEditingController();
  late IO.Socket? socket = SocketManager.singleton.socket;

  @override
  void initState() {
    socket?.on("checkPassword", (data) => {
      if (data) {
        SocketManager.singleton.logged = true,
        Navigator.pushReplacementNamed(context, '/home')
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: size.height * 0.2, top: size.height * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20,),
              Text("Hello, \nWelcome Back", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: size.width * 0.1, fontFamily: 'Poppins')),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        width: 30,
                        image: AssetImage('assets/icons/google.png')
                      )
                    ],
                  ),
                  const SizedBox(height: 50,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email"
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextField(
                      controller: _passwordTextController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password"
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: Text("Forgot Password?", style: Theme.of(context).textTheme.bodyText1),
                  // )
                ],
              ),
              Column(
                children: [
                  MaterialButton(
                    onPressed: () async {
                      final message = await AuthService().login(email: _emailTextController.text, password: _passwordTextController.text);
                      
                      if (kDebugMode) {
                        print(message);
                      }

                      if (message!.user!.uid.isNotEmpty) {
                        // print(FirebaseAuth.instance.currentUser!.uid);
                        SocketManager.shared.socket?.once("getUser", (data) => {
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
                            print(data["accounts"][i]),
                          },
                          user.selectedAccount = user.accounts[0],
                          // user.customerID = data["customerID"],
                          // user.email = data["email"],
                          // user.name = data["name"],
                          // user.firstName = data["firstName"],
                          // user.lastName = data["lastName"],
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(body: Text("Tes"),),))
                        });
                        socket!.emit("getUser", FirebaseAuth.instance.currentUser?.uid);
                        // await Future.delayed(const Duration(seconds: 1));
                        // if (!context.mounted) return;
                        // Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        if (kDebugMode) {
                          print("Gagal login");
                        }
                      }
                      // socket?.emit("checkPassword", {'email': _emailTextController.text, 'password': _passwordTextController.text});
                    },
                    elevation: 0,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.black,
                    textColor: Colors.white,
                    child: const Center(child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),)),
                  ),
                  const SizedBox(height: 30,),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                      // Navigator.push(context, MaterialPageRoute(builder: (context()));
                    },
                    child: Text("Create account", style: Theme.of(context).textTheme.bodyText1,),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
