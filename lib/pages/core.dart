
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wallet/commons/globalvariable.dart';
import 'package:wallet/entity/User.dart';
import 'package:wallet/pages/accountmanagement.dart';
import 'package:wallet/pages/home.dart';
import 'package:wallet/pages/profile.dart';
import 'package:wallet/pages/scan.dart';

import '../commons/socket_helper.dart';

class CorePage extends StatefulWidget {
  const CorePage({super.key});

  @override
  State<CorePage> createState() => _CorePageState();
}

class _CorePageState extends State<CorePage> {
  // bool isAccountsLoaded = false;
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomePage(),
    const AccountManagementPage(),
    const ScanPage(),
    const ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromRGBO(52, 90, 251, 1),
        animationDuration: const Duration(milliseconds: 600),
        // buttonBackgroundColor: Colors.black,
        animationCurve: Curves.fastOutSlowIn,
        color: Colors.white,
        height: 75,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(index);
            if (index == 1) {
              if (!GlobalVariable.isAccountsLoaded) {
                print(user.customerID);
                SocketManager.shared.socket?.emit("getAccounts", user.customerID);
                GlobalVariable.customerID = user.customerID;
              }
            }
          });
        },
        items: [
          Icon(Iconsax.home, color: Colors.grey.shade700,),
          Icon(Iconsax.key_square, color: Colors.grey.shade700,),
          Icon(Iconsax.scan_barcode, color: Colors.grey.shade700,),
          Icon(Iconsax.user, color: Colors.grey.shade700,),
        ],
      ),
    );
  }
}
