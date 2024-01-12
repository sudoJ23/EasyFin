import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyfin/auth/auth_service.dart';
import 'package:easyfin/commons/socket_helper.dart';
import 'package:easyfin/entity/User.dart';

import '../entity/accounts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();

  void signUp() async {
    if (passwordConfirmed()) {
      try {
        UserCredential userCredential = await AuthService().register(
          email: _emailController.text,
          password: _passwordController.text
        );

        SocketManager.shared.socket?.emit("register", {
          'uid': userCredential.user?.uid,
          'name': _firstNameController.text,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text
        });
        SocketManager.shared.socket?.once("register", (result) {
          if (result["status"] == "success") {
            SocketManager.shared.socket!.emit("getUser", userCredential.user?.uid);
            SocketManager.shared.socket!.once("getUser", (data) => {
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
              Navigator.pushReplacementNamed(context, '/gate')
            });
          }
        });
      } catch (e) {
        if (e.toString() == "Exception: [firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Email telah digunakan oleh pengguna lain",
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Error ${e.toString()}",
              ),
            ),
          );
        }
      }
    }
  }

  bool passwordConfirmed() {
    String password = _passwordController.text;
    String confirmation = _passwordConfirmationController.text;

    if (password != confirmation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password tidak sesuai"),
        ),
      );
      return false;
    }

    if (
      password.length < 6 ||
      !RegExp(r'[A-Z]').hasMatch(password) ||
      !RegExp(r'[a-z]').hasMatch(password) ||
      !RegExp(r'[0-9]').hasMatch(password)
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password must be at least 8 characters long and contain at least have upper case letters, lower case letters, and have numbers",
          ),
        ),
      );

      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/login");
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            padding: EdgeInsets.only(left: 20, right: 20, top: size.height * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20,),
                Text("Create, \nA new account", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: size.width * 0.09, fontFamily: 'Poppins')),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(20))
                            ),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "First Name",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(20))
                            ),
                            child: TextField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Last name"
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      margin: const EdgeInsets.all(5),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          prefixIcon: Icon(Iconsax.sms)
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      margin: const EdgeInsets.all(5),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                          prefixIcon: Icon(Iconsax.call)
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      margin: const EdgeInsets.all(5),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          prefixIcon: Icon(Iconsax.key)
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      margin: const EdgeInsets.all(5),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextField(
                        controller: _passwordConfirmationController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password Confirmation",
                          prefixIcon: Icon(Iconsax.key)
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: signUp,
                      elevation: 0,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.black,
                      textColor: Colors.white,
                      child: const Center(child: Text("Register", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),)),
                    ),
                    const SizedBox(height: 30,),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text("Login", style: Theme.of(context).textTheme.bodyText1,),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}