import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:panelverse/main.dart';

Future<void> openApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const PanelVerseApp());
  await tester.pumpAndSettle();
}

Future<void> tapKey(WidgetTester tester, String key) async {
  final target = find.byKey(Key(key));
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> fillField(WidgetTester tester, String key, String value) async {
  final target = find.byKey(Key(key));
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.enterText(target, value);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Sign up passes full name; logout clears the navigation stack',
      (tester) async {
    await openApp(tester);
    await tapKey(tester, 'openSignUp');
    expect(find.byType(SignUpScreen), findsOneWidget);

    await fillField(tester, 'signUpName', '  Red Santos  ');
    await fillField(tester, 'signUpEmail', 'red@example.com');
    await fillField(tester, 'signUpPassword', 'reader123');
    await fillField(tester, 'signUpConfirm', 'reader123');
    await tapKey(tester, 'signUpButton');

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Welcome,\nRed Santos.'), findsOneWidget);
    final homeContext = tester.element(find.byType(HomeScreen));
    expect(Navigator.canPop(homeContext), isFalse);

    await tapKey(tester, 'logoutButton');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    final loginContext = tester.element(find.byType(LoginScreen));
    expect(Navigator.canPop(loginContext), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Back to login pops Sign Up and preserves the Login route',
      (tester) async {
    await openApp(tester);
    await fillField(tester, 'loginUsername', 'reader');
    await tapKey(tester, 'openSignUp');
    await tapKey(tester, 'backToLogin');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('reader'), findsOneWidget);
    expect(Navigator.canPop(tester.element(find.byType(LoginScreen))), isFalse);
  });

  testWidgets('Empty login is rejected; valid demo login opens Home',
      (tester) async {
    await openApp(tester);
    await tapKey(tester, 'loginButton');
    expect(find.text('Enter your email or username.'), findsOneWidget);
    expect(find.text('Enter a password.'), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);

    await fillField(tester, 'loginUsername', 'reader@example.com');
    await fillField(tester, 'loginPassword', 'reader123');
    await tapKey(tester, 'loginButton');
    expect(find.text('Welcome,\nreader.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Invalid email and mismatched passwords prevent sign up',
      (tester) async {
    await openApp(tester);
    await tapKey(tester, 'openSignUp');
    await fillField(tester, 'signUpName', 'Red');
    await fillField(tester, 'signUpEmail', 'invalid-email');
    await fillField(tester, 'signUpPassword', 'reader123');
    await fillField(tester, 'signUpConfirm', 'different123');
    await tapKey(tester, 'signUpButton');
    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(find.text('Passwords do not match.'), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });
}
