import 'package:flutter_test/flutter_test.dart';
import 'package:ar_furniture_app/items.dart';

void main() {
  group('Items', () {
    // Test de la création d'une instance à partir d'un JSON
    test('should create an instance from JSON', () {
      final json = {
        'itemID': '123',
        'itemName': 'Chair',
        'itemDescription': 'A wooden chair',
        'itemImage': 'http://example.com/image.jpg',
        'sellerName': 'John Doe',
        'sellerPhone': '1234567890',
        'itemPrice': 150.0,
        'createdAt': '2023-10-03T00:00:00Z',
        'status': 'Available'
      };
      final item = Items.fromJson(json);

      expect(item.itemID, '123');
      expect(item.itemName, 'Chair');
      expect(item.itemDescription, 'A wooden chair');
      expect(item.itemImage, 'http://example.com/image.jpg');
      expect(item.sellerName, 'John Doe');
      expect(item.sellerPhone, '1234567890');
      expect(item.itemPrice, 150.0);
      // La vérification pour createdAt pourrait nécessiter une conversion de la date.
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

      expect(item.itemID, '');
      expect(item.itemName, '');
      expect(item.itemDescription, '');
      expect(item.itemImage, '');
      expect(item.sellerName, '');
      expect(item.sellerPhone, '');
      expect(item.itemPrice, 0.0);
      expect(item.createdAt, '');
      expect(item.status, '');
    });
  });
}
