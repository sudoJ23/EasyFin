import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wallet/commons/socket_helper.dart';
import 'package:wallet/entity/Transfer.dart';
import 'package:wallet/entity/User.dart';

import '../entity/contact.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final List<Contact> _recentContacts = [];
  final List<Contact> _contacts = [
  ];
  // final List<String> _contacts = [];

  final List<Contact> _filteredContact = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  void getContacts() {
    SocketManager.shared.socket?.emit("getContacts", user.uid);
    SocketManager.shared.socket?.once("getContacts", (data) => {
      _contacts.clear(),
      _filteredContact.clear(),
      print(data),
      for (var c in data) {
        _contacts.add(Contact(c["id"], c["first_name"], c["last_name"], c["email"], c["customerID"]))
      },
      _contacts.sort((a, b) => a.firstName.compareTo(b.firstName)),
      _filteredContact.sort((a, b) => a.firstName.compareTo(b.firstName)),
      setState(() {
        _filteredContact.addAll(_contacts);
      })
    });
  }

  void filterSearchResults(String query) {
    List<Contact> searchResults = [];
    if (query.isNotEmpty) {
      for (var contact in _contacts) {
        if (contact.firstName.toLowerCase().contains(query.toLowerCase()) || contact.lastName.toLowerCase().contains(query.toLowerCase())) {
          searchResults.add(contact);
        }
      }
    } else {
      searchResults.addAll(_contacts);
    }
    setState(() {
      _filteredContact.clear();
      _filteredContact.addAll(searchResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Kontak', style: TextStyle(color: Colors.black),),
        leading: BackButton(color: Colors.black, onPressed: () {
          Navigator.pop(context, Transfer.amount);
        },),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  filterSearchResults(value);
                },
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Cari kontak',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  )
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10,),
            FadeInRight(
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 15, top: 10),
                child: Text('Most Recent', style: TextStyle(fontSize: 16, color: Colors.grey.shade900, fontWeight: FontWeight.w500),),
              ),
            ),
            _recentContacts.isNotEmpty ? Container(
              height: 90,
              padding: const EdgeInsets.all(20),
              child: FadeInRight(
                duration: const Duration(milliseconds: 500),
                child: const Text("No recent contact"),
              ),
            ) : 
            Container(
              height: 90,
              padding: const EdgeInsets.only(left: 20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FadeInRight(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blueGrey[100],
                              child: const Icon(Iconsax.user),
                            ),
                            const SizedBox(height: 10,),
                            const Text("Jeremi", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            FadeInRight(
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/contact/new').then((value) {
                    if (value != null && value == "new contact") {
                      getContacts();
                    }
                  });
                },
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: const Color.fromRGBO(52, 90, 251, 1)
                  ),
                  child: Center(
                    child: Text("Kontak Baru", style: TextStyle(color: Colors.grey.shade100, fontWeight: FontWeight.w400)),
                  )
                ),
              ),
            ),
            const SizedBox(height: 10,),
            FadeInRight(
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 15.0, top: 10.0),
                child: Text('All Contacts', style: TextStyle(fontSize: 16, color: Colors.grey.shade900, fontWeight: FontWeight.w500),),
              ),
            ),
            _contacts.isEmpty ? 
            FadeInRight(
              duration: const Duration(milliseconds: 500),
              child: Center(
                child: Text(
                  "Anda tidak memiliki kontak",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.grey.shade700),
                ),
              ),
            ) :
            Container(
              height: MediaQuery.of(context).size.height - 200,
              padding: const EdgeInsets.only(left: 20),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _filteredContact.length,
                itemBuilder: (context, index) {
                  return FadeInRight(
                    duration: Duration(milliseconds: (index * 100) + 500),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/transfer', arguments: _filteredContact[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blueGrey[100],
                              child: const Icon(Iconsax.user),
                            ),
                            const SizedBox(width: 10,),
                            Text("${_filteredContact[index].firstName} ${_filteredContact[index].lastName}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15,),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
