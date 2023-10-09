import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ar_furniture_app/items.dart';

void main() {
  group('Items', () {
    // Test de la création d'une instance à partir d'un JSON
    test('Item should have correct properties', () {
      final item = Items(
        itemID: '123',
        itemName: 'Chair',
        itemDescription: 'A wooden chair',
        itemImage: 'http://example.com/image.jpg',
        sellerName: 'John Doe',
        sellerPhone: '1234567890',
        itemPrice: "150.0",
        createdAt: Timestamp.fromDate(DateTime(2023, 10, 4)), // fournir un Timestamp pour le test
        status: 'Available',
      );

      expect(item.itemID, '123');
      expect(item.itemName, 'Chair');
      expect(item.itemDescription, 'A wooden chair');
      expect(item.itemImage, 'http://example.com/image.jpg');
      expect(item.sellerName, 'John Doe');
      expect(item.sellerPhone, '1234567890');
      expect(item.itemPrice, "150.0");
      expect(item.createdAt, Timestamp.fromDate(DateTime(2023, 10, 4)));
      expect(item.status, 'Available');
    });


    // Test pour vérifier le comportement quand des données incorrectes ou manquantes sont fournies
    test('should handle missing keys in JSON', () {
      final json = {
        'itemID': '124',
        'itemDescription': 'A wooden table',
        // 'itemName' manquant
        // 'itemImage' manquant
        // ... autres clés manquantes
      };
      final item = Items.fromJson(json);

      expect(item.itemID, '124');
      expect(item.itemName, '');
      expect(item.itemDescription, '');
      expect(item.itemImage, '');
      expect(item.sellerName, '');
      expect(item.sellerPhone, '');
      expect(item.itemPrice, "0.0");
      expect(item.createdAt, '');
      expect(item.status, '');
    });
  });
}
