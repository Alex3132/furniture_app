import 'package:ar_furniture_app/screens/virtual_ar_view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import '../items.dart';
import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatefulWidget
{
  Items? clickedItemInfo;

  ItemDetailsScreen({this.clickedItemInfo});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}




class _ItemDetailsScreenState extends State<ItemDetailsScreen>
{
  // Fonction pour confirmer et effectuer la suppression
  void _confirmAndDeleteItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content: const Text("Voulez-vous vraiment supprimer cet élément ?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Supprimer"),
              onPressed: () async {
                try {
                  // Supprimez l'élément de la base de données Firestore
                  await FirebaseFirestore.instance
                      .collection('items')
                      .doc(widget.clickedItemInfo!.itemID)
                      .delete();

                  String? imageUrl = widget.clickedItemInfo!.itemImage;

                  print("Image URL : $imageUrl");
                  // Divisez l'URL par '/' pour obtenir les parties de l'URL
                  List<String> urlParts = imageUrl!.split('/');

                  // Récupérez le dernier élément du tableau (qui contient le nom du fichier)
                  String imageFileNameWithExtension = urlParts.last;

                  // Supprimez l'extension du nom du fichier
                  int indexOfQuestionMark = imageFileNameWithExtension.indexOf('?');
                  String imageFileName = imageFileNameWithExtension.substring(0, indexOfQuestionMark);
                  imageFileName = imageFileName.replaceAll("Items%20Images%2F", "");

                  print("Nom du fichier de l'image : $imageFileName");
                  await fStorage.FirebaseStorage.instance
                      .ref()
                      .child('Items Images')
                      .child(imageFileName!)
                      .delete();
                  Navigator.of(context).pop();
                  // Après la suppression, revenez à l'écran précédent.
                  Navigator.of(context).pop();
                } catch (e) {
                  print("Erreur lors de la suppression : $e");
                  // Gérez les erreurs de suppression ici.
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
