import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyfin/entity/Transfer.dart';

class NoteModal extends StatefulWidget {
  final String note;
  const NoteModal({super.key, required this.note});

  @override
  State<NoteModal> createState() => _NoteModalState();
}

class _NoteModalState extends State<NoteModal> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  double containerHeight = 500;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    _focusNode.requestFocus();
    _editingController.text = widget.note;
    // if (isKeyboardVisible) {
    //   setState(() {
    //     containerHeight = 450;
    //   });
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Container(
      height: isKeyboardVisible ? 500 : 250,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tambah Keterangan",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              IconButton(
                icon: const Icon(Iconsax.close_circle),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          TextField(
            controller: _editingController,
            autofocus: true,
            maxLength: 32,
            focusNode: _focusNode,
            maxLengthEnforcement:
                MaxLengthEnforcement.truncateAfterCompositionEnds,
          ),
          GestureDetector(
            onTap: () {
              Transfer.note = _editingController.text;
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 20),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: const Color.fromRGBO(52, 90, 251, 1),
              ),
              child: Text(
                "Simpan",
                style: TextStyle(
                    color: Colors.grey.shade100,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}
