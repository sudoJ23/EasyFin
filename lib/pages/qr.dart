import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class Qr extends StatefulWidget {
  const Qr({super.key});

  @override
  State<Qr> createState() => _QrState();
}

class _QrState extends State<Qr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Share Account"),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width / 1.5,
          child: PrettyQrView.data(
            data: 'lorem ipsum dolor sit amet',
          ),
        ),
      ),
    );
  }
}
