import 'package:flutter/material.dart';

class KeyPadNumber extends StatelessWidget {
  final num number;
  const KeyPadNumber({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(number);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        // height: 50,
        width: 50,
        margin: EdgeInsets.all(20),
        // color: Colors.red,
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
              fontSize: 32,
              fontFamily: 'Poppins'
            ),
          ),
        ),
      ),
    );
  }
}
