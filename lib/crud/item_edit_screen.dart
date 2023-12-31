import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ar_furniture_app/items.dart'; // Assurez-vous que le chemin d'importation est correct

class ItemEditScreen extends StatefulWidget {
  final Items? clickedItemInfo;

  const ItemEditScreen({super.key, this.clickedItemInfo});

  @override
  _ItemEditScreenState createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  late TextEditingController _itemNameController;
  late TextEditingController _itemDescriptionController;
  late TextEditingController _itemPriceController;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.clickedItemInfo?.itemName);
    _itemDescriptionController = TextEditingController(text: widget.clickedItemInfo?.itemDescription);
    _itemPriceController = TextEditingController(text: widget.clickedItemInfo?.itemPrice.toString());
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemDescriptionController.dispose();
    _itemPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.clickedItemInfo?.itemName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _itemNameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
              ),
            ),
            TextField(
              controller: _itemDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Item Description',
              ),
            ),
            TextField(
              controller: _itemPriceController,
              decoration: const InputDecoration(
                labelText: 'Item Price',
              ),
            ),
            ElevatedButton(
              onPressed: _saveItem,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveItem() async {
    // Validation des champs
    if (_itemNameController.text.isEmpty ||
        _itemDescriptionController.text.isEmpty ||
        _itemPriceController.text.isEmpty) {
      // Vous pouvez montrer une alerte ou un message ici
      print("All fields are required.");
      return;
    }

    try {
      // Mettez à jour le document dans Firestore
      await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.clickedItemInfo?.itemID) // Utilisez l'ID de l'élément ici
          .update({
        'itemName': _itemNameController.text,
        'itemDescription': _itemDescriptionController.text,
        'itemPrice': _itemPriceController.text,
        // Ajoutez ici toutes les autres propriétés que vous souhaitez mettre à jour
      });

      // Optionnel : Affichez un message de succès et revenez à l'écran précédent
      print("Item updated successfully");
      Navigator.of(context).pop();
    } catch (e) {
      // Gérez les erreurs ici (par exemple, affichez un message d'erreur)
      print("Error updating item: $e");
    }
  }


}
