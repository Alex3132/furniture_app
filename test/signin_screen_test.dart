import 'package:ar_furniture_app/screens/reset_password.dart';
import 'package:ar_furniture_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ar_furniture_app/screens/signin_screen.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('SignInScreen', () {
    late MockNavigatorObserver navigatorObserver;
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      navigatorObserver = MockNavigatorObserver();
      mockFirebaseAuth = MockFirebaseAuth();
    });

    testWidgets('renders SignInScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SignInScreen(),
          navigatorObservers: [navigatorObserver],
        ),
      );

      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text("Don't have account?"), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('navigates to SignUpScreen on tap', (WidgetTester tester) async {
      // Utilisation de FakeNavigatorObserver
      final fakeObserver = FakeNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: const SignUpScreen(),
          navigatorObservers: [fakeObserver],  // Utilisation du FakeObserver ici
        ),
      );

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Vérification que l'événement didPush a été déclenché
      expect(fakeObserver.pushCount, 1);
    });

    testWidgets('navigates to SignUpScreen on tap', (WidgetTester tester) async {
      final fakeObserver = FakeNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: const SignInScreen(),
          navigatorObservers: [fakeObserver],
        ),
      );

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify that a push event happened on navigator
      expect(fakeObserver.pushCount, 1);
    });

    // ... Other tests
  });
}

class FakeNavigatorObserver extends NavigatorObserver {
  int pushCount = 0;

  @override
  void didPush(Route route, Route? previousRoute) {
    pushCount++;
    super.didPush(route, previousRoute);
  }
}