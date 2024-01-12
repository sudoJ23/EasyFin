import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:easyfin/commons/socket_helper.dart';
import 'package:easyfin/entity/contact.dart';
import 'package:easyfin/entity/Transfer.dart';
import 'package:easyfin/entity/User.dart';
import 'package:easyfin/widgets/notemodal.dart';
import 'package:easyfin/widgets/transfer_confirmation.dart';

import '../entity/accounts.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  Accounts _selectedAccount = Accounts("", "", "", 0, "", "", "", "", "");
  final bool isLoading = true;
  late Contact data = Contact("", "", "", "", "", "");
  final List<Accounts> _accounts = [];
  final TextEditingController _nominalController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool nextable = false;

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 0
  );

  @override
  void initState() {
    super.initState();
    Transfer.amount = 0;
    Transfer.note = "";
    _nominalController.text = "0";
    _focusNode.requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data = ModalRoute.of(context)!.settings.arguments as Contact;
      if (kDebugMode) {
        print(data.id);
      }
      SocketManager.shared.socket?.emit("getAccounts", data.customerID);
      SocketManager.shared.socket?.once("getAccounts", (result) => {
        for (var i = 0; i < result.length; i++) {
          _accounts.add(
            Accounts(
              result[i]["id"],
              result[i]["name"],
              result[i]["customer_id"],
              int.parse(result[i]["balance"]),
              result[i]["account_status"],
              result[i]["account_type"],
              result[i]["currency"],
              result[i]["pancard_no"],
              ""
            )
          )
        },
        setState(() {
          _selectedAccount = _accounts[0];
        })
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            title: Container(
              margin: const EdgeInsets.only(left: 60),
              child: Text(
                data.firstName,
                style: const TextStyle(color: Colors.black),),
            ),
            leading: const BackButton(color: Colors.black),
            elevation: 0,
          ),
          SliverList(delegate: SliverChildListDelegate([
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: const Color.fromRGBO(52, 90, 251, 1),
              ),
              child: Column(
                children: [
                  Text(
                    "Rekening",
                    style: TextStyle(
                      color: Colors.grey.shade100,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.grey.shade100
                    ),
                    child: DropdownButton<Accounts>(
                      onChanged:(value) {
                        if (value != null) {
                          setState(() {
                            _selectedAccount = value;
                          });
                        }
                      },
                      value: _selectedAccount,
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.grey.shade100,
                      elevation: 2,
                      icon: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Icon(Iconsax.arrow_square_down, color: Color.fromRGBO(52, 90, 251, 1), size: 18,)
                      ),
                      underline: Container(height: 0),
                      items: _accounts.map<DropdownMenuItem<Accounts>>((Accounts account) {
                        return DropdownMenuItem(
                          value: account,
                          child: Text(
                            account.pancard,
                            style: const TextStyle(color: Color.fromRGBO(52, 90, 251, 1),),
                          ),
                        );
                      }).toList()
                    ),
                  ),
                  const SizedBox(height: 40,),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Nominal",
                            style: TextStyle(
                              color: isBalanceEnough() ? Colors.grey.shade100 : Colors.red
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        controller: _nominalController,
                        focusNode: _focusNode,
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey.shade100,
                          fontFamily: 'Poppins'
                        ),
                        onChanged: (value) {
                          if (_nominalController.text.isNotEmpty) {
                            setState(() {
                              if (isBalanceEnough()) {
                                nextable = true;
                              } else {
                                nextable = false;
                              }
                              _nominalController.text = currencyFormatter.format(int.parse(value));
                            });
                          } else {
                            setState(() {
                              isBalanceEnough();
                              nextable = false;
                              _nominalController.text = "0";
                            });
                          }
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: isBalanceEnough() ? Colors.grey.shade100 : Colors.red,
                              style: BorderStyle.solid
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: isBalanceEnough() ? Colors.grey.shade100 : Colors.red,
                              style: BorderStyle.solid
                            ),
                          ),
                          prefix: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Text(
                              "Rp",
                              style: TextStyle(
                                color: Colors.grey.shade100,
                                fontFamily: 'Poppins',
                                fontSize: 30
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "Rekening sumber",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: 'Poppins'
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: user.accounts.map(
                    (account) => GestureDetector(
                      onTap: () {
                        setState(() {
                          user.selectedAccount = account;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                        padding: const EdgeInsets.only(left: 10, right: 25, top: 10, bottom: 10),
                        width: 180,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: Colors.white,
                          shadows: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  account.name,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    fontSize: 18
                                  ),
                                ),
                                user.selectedAccount != account ? const Icon(Iconsax.tick_circle3) : const Icon(
                                  Iconsax.tick_circle5,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                            Text(
                              account.pancard,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Poppins',
                                fontSize: 14
                              ),
                            ),
                            Text(
                              "Rp ${currencyFormatter.format(account.balance)}",
                              style: const TextStyle(
                                color: Color.fromRGBO(52, 90, 251, 1),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16
                              ),
                            )
                          ],
                        )
                      ),
                    )
                  ).toList()
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  enableDrag: false,
                  isDismissible: false,
                  isScrollControlled: false,
                  builder: (context) => KeyboardVisibilityProvider(child: NoteModal(note: Transfer.note,)),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.edit,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      "Tambah keterangan",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (nextable) {
                  num nominal = 0;
                  if (_nominalController.text.contains(".")) {
                    nominal = int.parse(_nominalController.text.replaceAll(".", ""));
                  } else {
                    nominal = int.parse(_nominalController.text);
                  }

                  if (nominal > 0 && isBalanceEnough()) {
                    Transfer.receiverName = "${data.firstName} ${data.lastName}";
                    Transfer.receiverPancard = _selectedAccount.pancard;
                    Transfer.amount = nominal;
                    Transfer.accountId = _selectedAccount.id;
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: false,
                      isDismissible: false,
                      showDragHandle: false,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      builder: (context) => TransferConfirmation(nominal: nominal, receiverName: "${data.firstName} ${data.lastName}", receiverPancard: _selectedAccount.pancard,)
                    );
                  } else {
                    _focusNode.requestFocus();
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  color: nextable ? const Color.fromRGBO(52, 90, 251, 1) : const Color.fromRGBO(131, 141, 185, 1)
                ),
                child: Center(
                  child: Text(
                    "Lanjutkan",
                    style: TextStyle(
                      color: Colors.grey.shade100,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
              ),
            ),
          ])),
        ],
      )
    );
  }

  bool isBalanceEnough() {
    num nominal = 0;
    if (_nominalController.text.contains(".")) {
      nominal = int.parse(_nominalController.text.replaceAll(".", ""));
    } else {
      nominal = int.tryParse(_nominalController.text) ?? 0;
    }
    return nominal <= user.selectedAccount.balance;
  }
}