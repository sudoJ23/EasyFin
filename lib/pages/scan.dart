import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:easyfin/commons/globalvariable.dart';
import 'package:easyfin/entity/User.dart';

import '../commons/socket_helper.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  late Map data;
  String qrcode = "";
  String hasil = "";
  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  @override
  void initState() {
    super.initState();
    if (GlobalVariable.qrViewController != null) {
      GlobalVariable.qrViewController!.pauseCamera();
    }
  }

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
    return const Scaffold(
      body: Center(
        child: Text("Scan QRCode"),
      )
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    GlobalVariable.qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrcode = scanData.code!;
        try {
          data = json.decode(qrcode);
          GlobalVariable.qrViewController?.pauseCamera();
          if (data["valid"] == "true") {
            addContact(stringToBase64.decode(data["data"]));
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        result = scanData;
      });
    });
  }

  void addContact(uid) {
    SocketManager.shared.socket?.emit("addContact", {"ownerID": user.uid, "userID": uid});
    SocketManager.shared.socket?.once("addContact", (result) {
      if (result["status"] == "failed") {
        if (result["message"] == "cannot added yourself") {
          showMessage("Peringatan", "Tidak dapat menambahkan diri anda sendiri", context);
        } else if (result["message"] == "contact has been saved") {
          showMessage("Peringatan", "Kontak telah ada", context);
        }
      } else if (result["status"] == "success") {
        showMessage("Berhasil", "Berhasil menambahkan kontak", context);
      }
    });
  }

  @override
  void dispose() {
    GlobalVariable.qrViewController?.dispose();
    super.dispose();
  }
}