import 'dart:html';

import 'package:client_holder/controllers/authentication.dart';
import 'package:client_holder/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //collection reference
  final CollectionReference _clients =
      FirebaseFirestore.instance.collection('Client');

  //textcontroller for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  //update method
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['Name'];
      _gstController.text = documentSnapshot['GST'];
    }

    await showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _gstController,
                  decoration: InputDecoration(labelText: "GST"),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name = _nameController.text;
                      final String GST = _gstController.text;

                      await _clients
                          .doc(documentSnapshot!.id)
                          .update({"Name": name, "GST": GST});
                      _nameController.text = '';
                      _gstController.text = '';
                      Navigator.of(context).pop();
                    },
                    child: Text("Update"))
              ],
            ),
          );
        });
  }

  //create method
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['Name'];
      _gstController.text = documentSnapshot['GST'];
    }

    await showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _gstController,
                  decoration: InputDecoration(labelText: "GST"),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name = _nameController.text;
                      final String GST = _gstController.text;

                      await _clients.add(
                          {"Name": name, "GST": GST, "user_id": widget.uid});
                      _nameController.text = '';
                      _gstController.text = '';

                      Navigator.of(context).pop();
                    },
                    child: Text("Create Client"))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text("Client Holder"),
        centerTitle: true,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                signOutUser();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: StreamBuilder(
            stream: _clients
                .where("user_id", isEqualTo: widget.uid)
                .snapshots(), //build connection
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(documentSnapshot['Name']),
                        subtitle: Text(documentSnapshot['GST']),
                        trailing: Container(
                          width: 120,
                          child: Row(children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade300,
                                  shape: BoxShape.circle),
                              child: IconButton(
                                  onPressed: () {
                                    _update(documentSnapshot);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
                            )),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  shape: BoxShape.circle),
                              child: IconButton(
                                  onPressed: () {
                                    _clients.doc(documentSnapshot!.id).delete();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  )),
                            )),
                          ]),
                        ),
                      ),
                    );
                  }),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _create();
        },
        child: Icon(
          Icons.add_rounded,
          size: 40,
        ),
        backgroundColor: Colors.blue.shade300,
        elevation: 2,
      ),
    );
  }
}
