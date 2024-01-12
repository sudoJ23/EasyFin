import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyfin/pages/pinconfirmation.dart';
import 'package:easyfin/widgets/keypadnumber.dart';

class KeyPad extends StatefulWidget {
  const KeyPad({super.key});

  @override
  State<KeyPad> createState() => _KeyPadState();
}

class _KeyPadState extends State<KeyPad> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KeyPadNumber(number: 1),
              KeyPadNumber(number: 2),
              KeyPadNumber(number: 3),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KeyPadNumber(number: 4),
              KeyPadNumber(number: 5),
              KeyPadNumber(number: 6),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KeyPadNumber(number: 7),
              KeyPadNumber(number: 8),
              KeyPadNumber(number: 9),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(20),
                child: const Center(
                  child: Text(
                    "Lupa?",
                    style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                  ),
                ),
              ),
              KeyPadNumber(number: 0),
              Container(
                width: 50,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(20),
                child: const Center(child: Icon(Iconsax.arrow_left_1)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
