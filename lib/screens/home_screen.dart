import 'package:ar_furniture_app/items_ui_design_widget.dart';
import 'package:ar_furniture_app/crud/items_upload_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ar_furniture_app/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
          title : const Text(
              "Kawa mobile App",
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        actions: [
          IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (c) => const ItemsUploadScreen()));
    }, icon: const Icon(
      Icons.add,
      color : Colors.white
    )
      )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("items")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot dataSnapshot){
          if(dataSnapshot.hasData){
            return ListView.builder(
              itemCount: dataSnapshot.data!.docs.length,
              itemBuilder: (context, index){
                Items eachItemInfo = Items.fromJson(
                  dataSnapshot.data!.docs[index].data() as Map<String, dynamic>
                );

                return ItemUIDesignWidget(
                  itemsInfo: eachItemInfo,
                  context: context,
                );
              },
            );
          }else{
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Data is not available",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey,
                    )
                  ),
                )
              ],
            );
          }
        },
      ),
      // Ajoutez le bouton "Logout" en bas à gauche
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            print("Signed Out");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          });
        },
        child: const Icon(Icons.logout), // Icône de déconnexion
        backgroundColor: Colors.red, // Couleur du bouton
        foregroundColor: Colors.white, // Couleur de l'icône
        tooltip: "Logout", // Info-bulle au survol
      ),
    );
  }
}
