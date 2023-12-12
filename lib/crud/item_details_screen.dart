import 'package:ar_furniture_app/screens/home_screen.dart';
import 'package:ar_furniture_app/screens/virtual_ar_view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:fluttertoast/fluttertoast.dart';
import '../items.dart';
import 'package:flutter/material.dart';

import '../crud/item_edit_screen.dart';

class ItemDetailsScreen extends StatefulWidget
{
  Items? clickedItemInfo;

  ItemDetailsScreen({super.key, required this.clickedItemInfo});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}




class _ItemDetailsScreenState extends State<ItemDetailsScreen>
{

  void _navigateToEditItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemEditScreen(
          clickedItemInfo: widget.clickedItemInfo,
        ),
      ),
    );
  }

  // Fonction pour confirmer et effectuer la suppression
  void _confirmAndDeleteItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Do you really want to delete this item?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                try {
                  // Delete item from Firestore database
                  await FirebaseFirestore.instance
                      .collection('items')
                      .doc(widget.clickedItemInfo!.itemID)
                      .delete();

                  String? imageUrl = widget.clickedItemInfo!.itemImage;

                  // Split the URL by '/' to get the parts of the URL
                  List<String> urlParts = imageUrl!.split('/');

                  // Get the last element of the array (which contains the file name)
                  String imageFileNameWithExtension = urlParts.last;

                  // Remove the extension from the file name
                  int indexOfQuestionMark = imageFileNameWithExtension.indexOf('?');
                  String imageFileName = imageFileNameWithExtension.substring(0, indexOfQuestionMark);
                  imageFileName = imageFileName.replaceAll("Items%20Images%2F", "");

                  print(imageFileName);

                  await fStorage.FirebaseStorage.instance
                      .ref()
                      .child('Items Images')
                      .child(imageFileName)
                      .delete();

                  Navigator.of(context).pop();  // Close the dialog
                  Navigator.of(context).pop();  // Go back to the previous screen

                  // Show the toast message
                  Fluttertoast.showToast(
                      msg: "Item deleted successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );

                  // Navigate to the home page
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                } catch (e) {
                  print("Error while deleting: $e");
                  // Handle deletion errors here.
                }
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.clickedItemInfo!.itemName.toString(),
        ),
        actions: [
          // Ajoutez un bouton de suppression dans la barre d'applications
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _confirmAndDeleteItem();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _navigateToEditItem(context);
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        onPressed: ()
        {
          //try item virtually (arview)
          Navigator.push(context, MaterialPageRoute(builder: (c)=> VirtualARViewScreen(
            clickedItemImageLink: widget.clickedItemInfo!.itemImage.toString(),
          )));
        },
        label: const Text(
          "Try Virtually (AR View)",
        ),
        icon: const Icon(
          Icons.mobile_screen_share_rounded,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Image.network(
                widget.clickedItemInfo!.itemImage.toString(),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Text(
                  widget.clickedItemInfo!.itemName.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                child: Text(
                  widget.clickedItemInfo!.itemDescription.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.white54,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${widget.clickedItemInfo!.itemPrice} €",
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white70,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 310.0),
                child: Divider(
                  height: 1,
                  thickness: 2,
                  color: Colors.white70,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
