import 'package:ar_furniture_app/crud/item_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ar_furniture_app/items.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('Item Details Screen Test', (WidgetTester tester) async {
    // Define a sample item
    Items testItem = Items(
      itemName: "Test Item",
      itemDescription: "This is a test item",
      itemImage: "https://example.com/image.jpg",
      itemPrice: "100",
      sellerName: "Test Seller",
      sellerPhone: "1234567890",
      status: "Available",
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: ItemDetailsScreen(clickedItemInfo: testItem),
    ));

    // Verify if the item name is displayed.
    expect(find.text('Test Item'), findsOneWidget);

    // Verify if the item description is displayed.
    expect(find.text('This is a test item'), findsOneWidget);

    // Verify if the item price is displayed.
    expect(find.text('100 €'), findsOneWidget);

    // Tap the delete icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    // Verify if the delete confirmation dialog is displayed.
    expect(find.text('Delete Confirmation'), findsOneWidget);
    expect(find.text('Do you really want to delete this item?'), findsOneWidget);
  });
}
