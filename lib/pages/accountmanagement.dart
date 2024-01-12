import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyfin/commons/socket_helper.dart';
import 'package:easyfin/entity/User.dart';


class AccountManagementPage extends StatefulWidget {
  const AccountManagementPage({super.key});

  @override
  State<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: false,
              title: Text(
                "Manajemen Rekening",
                style: TextStyle(color: Colors.grey.shade900),
              ),
              actions: [
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        "Buat Rekening Baru",
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
                              controller: _namaController,
                              decoration: const InputDecoration(
                                label: Text("Nama"),
                              ),
                            ),
                            TextField(
                              controller: _pinController,
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              decoration: const InputDecoration(
                                label: Text("Pin"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (_pinController.text.length >= 6) {
                              SocketManager.shared.socket?.once("createAccount", (data) {
                                if (data["status"] == "success") {
                                  SocketManager.shared.socket?.emit("getUser", user.uid);
                                  Navigator.pop(context);
                                }
                              });
                              SocketManager.shared.socket?.emit("createAccount", {'name': _namaController.text, 'customerID': user.customerID});
                            }
                          },
                          child: const Text("Buat"),
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
                  icon: const Icon(Iconsax.add),
                  color: Colors.grey.shade900,
                )
              ],
            ),
            SliverList.builder(
              itemCount: user.accounts.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: const Color.fromRGBO(52, 90, 251, 1)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.accounts[index].name,
                                style: TextStyle(
                                  color: Colors.grey.shade100,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                user.accounts[index].pancard,
                                style: TextStyle(
                                  color: Colors.grey.shade100,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/account/detail", arguments: user.accounts[index]).then((value) {
                                      if (value != null) {
                                        List<String> res = value.toString().split("|");
                                        if (res[0] == "renamed") {
                                          setState(() {
                                            if (user.selectedAccount.id == user.accounts[index].id) {
                                              user.selectedAccount.name = res[2];
                                              user.selectedAccount.pin = res[1];
                                            }
                                            user.accounts[index].pin = res[1];
                                            user.accounts[index].name = res[2];
                                          });
                                        }
                                      }
                                    });
                                  },
                                  icon: Icon(Iconsax.setting, color: Colors.grey.shade100),
                                )
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            )
            // SliverList(delegate: SliverChildListDelegate([
              
            // ]))
          ],
        ),
      ),
    );
  }
}
