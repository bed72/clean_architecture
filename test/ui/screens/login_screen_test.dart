import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bed/ui/screens/screens.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenterSpy? presenter;
  // ignore: close_sinks
  StreamController<String>? emailErrorController;
  // ignore: close_sinks
  StreamController<String>? passwordErrorController;
  // ignore: close_sinks
  StreamController<String>? mainErrorController;

  // ignore: close_sinks
  StreamController<bool>? isFormValidController;
  // ignore: close_sinks
  StreamController<bool>? isLoadingController;

  void _initStreams() {
    emailErrorController = StreamController<String>();
    mainErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();

    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void _mockStreams() {
    when(() => presenter!.emailErrorStream)
        .thenAnswer((_) => emailErrorController!.stream);

    when(() => presenter!.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController!.stream);

    when(() => presenter!.isFormValidErrorStream)
        .thenAnswer((_) => isFormValidController!.stream);

    when(() => presenter!.isLoadingStream)
        .thenAnswer((_) => isLoadingController!.stream);

    when(() => presenter!.mainErrorStream)
        .thenAnswer((_) => mainErrorController!.stream);
  }

  void _closeStreams() {
    emailErrorController!.close();
    passwordErrorController!.close();
    mainErrorController!.close();
    isFormValidController!.close();
    isLoadingController!.close();
  }

  Future<void> _loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();

    _initStreams();
    _mockStreams();

    final _loginScreen = MaterialApp(
      title: 'Flutter Tests',
      home: LoginScreen(presenter!),
    );

    await tester.pumpWidget(_loginScreen);
  }

  tearDown(() {
    _closeStreams();
  });

  testWidgets(' 🔧 Should load with correct initial state',
      (WidgetTester tester) async {
    await _loadPage(tester);

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no errors, since one the childs is always the childs is always the Label Text',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Password'),
      matching: find.byType(Text),
    );

    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no errors, since one the childs is always the childs is always the Label Text',
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets(' 🔧 Should call validate with correct values',
      (WidgetTester tester) async {
    await _loadPage(tester);

    /// Populando campo de e-mail
    final email = faker.internet.email();
    await tester.enterText(find.byKey(Key('inputTextEmailTest')), email);

    verify(() => presenter!.validateEmail(email));

    /// Populando campo de password
    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Password'), password);

    verify(() => presenter!.validatePassword(password));
  });

  testWidgets(' 🔧 Should present error if email is invalid',
      (WidgetTester tester) async {
    await _loadPage(tester);

    emailErrorController!.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets(' 🔧 Should present error if password is invalid',
      (WidgetTester tester) async {
    await _loadPage(tester);

    passwordErrorController!.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets(' 🔧 Should enable button if form is valid',
      (WidgetTester tester) async {
    await _loadPage(tester);

    isFormValidController!.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets(' 🔧 Should enable button if form is valid',
      (WidgetTester tester) async {
    await _loadPage(tester);

    isFormValidController!.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets(' 🔧 Should call authentication on from submit',
      (WidgetTester tester) async {
    await _loadPage(tester);

    isFormValidController!.add(true);
    await tester.pump();
    await tester.tap(find.byKey(Key('buttonLogin')));
    await tester.pump();

    verify(() => presenter!.auth()).called(1);
  });

  testWidgets(' 🔧 Should present loading', (WidgetTester tester) async {
    await _loadPage(tester);

    isLoadingController!.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(' 🔧 Should hide loading', (WidgetTester tester) async {
    await _loadPage(tester);

    isLoadingController!.add(true);
    await tester.pump();

    isLoadingController!.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets(' 🔧 Should present error message if authentication fails',
      (WidgetTester tester) async {
    await _loadPage(tester);

    mainErrorController!.add('main error');
    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });

  testWidgets(' 🔧 Should close streams on dispose',
      (WidgetTester tester) async {
    await _loadPage(tester);

    /// Ao distruir pagina/widget feche todas as streams
    addTearDown(() {
      verify(() => presenter!.dispose()).called(1);
    });
  });
}
