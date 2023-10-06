import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ar_furniture_app/items.dart';

class ItemEditScreen extends StatefulWidget {
  final DocumentSnapshot item;
  final Items clickedItemInfo;

  ItemEditScreen({required this.item, required this.clickedItemInfo});

  @override
  _ItemEditScreenState createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the text fields with existing data
    itemNameController.text = widget.clickedItemInfo.itemName ?? "";
    itemDescriptionController.text = widget.clickedItemInfo.itemDescription ?? "";
    itemPriceController.text = widget.clickedItemInfo.itemPrice ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Item"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveItemChanges,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: itemNameController,
              decoration: const InputDecoration(labelText: "Item Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: itemDescriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: itemPriceController,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveItemChanges,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  void _saveItemChanges() {
    final updatedItem = {
      'itemName': itemNameController.text,
      'itemDescription': itemDescriptionController.text,
      'itemPrice': itemPriceController.text,
    };

    FirebaseFirestore.instance
        .collection('items')
        .doc(widget.clickedItemInfo.itemID)
        .update(updatedItem)
        .then((value) => Navigator.pop(context))
        .catchError((error) => print("Failed to update item: $error"));
  }
}
