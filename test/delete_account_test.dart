import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_task_website/main.dart';

/// Fake backend: login always succeeds, delete answers [deleteStatus].
MockClient _backend(int deleteStatus, Map<String, dynamic> deleteBody, List<http.Request> seen) =>
    MockClient((req) async {
      seen.add(req);
      if (req.url.path.endsWith('/auth/login')) {
        return http.Response(jsonEncode({'token': 'jwt'}), 200);
      }
      return http.Response(jsonEncode(deleteBody), deleteStatus);
    });

Future<void> _submit(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
  await tester.enterText(find.byType(TextField).at(1), 'Strong@123');
  await tester.tap(find.byType(Checkbox));
  await tester.tap(find.text('Delete my account'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('success sends the token + password and shows the done card', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final seen = <http.Request>[];
    await tester.pumpWidget(DeleteAccountApp(
      client: _backend(200, {'success': true, 'message': 'Your account has been deleted'}, seen),
    ));

    await _submit(tester);

    expect(find.text('Your account has been deleted'), findsOneWidget);
    final del = seen.last;
    expect(del.method, 'DELETE');
    expect(del.headers['Authorization'], 'Bearer jwt');
    expect(jsonDecode(del.body), {'password': 'Strong@123'});
  });

  testWidgets('a refusal shows the backend message and keeps the form', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    const managed = 'This account is managed by your organisation. '
        'Please contact your administrator to delete it.';
    await tester.pumpWidget(DeleteAccountApp(
      client: _backend(403, {'error': managed, 'managedAccount': true}, []),
    ));

    await _submit(tester);

    expect(find.text(managed), findsOneWidget);
    expect(find.text('Delete my account'), findsOneWidget);
  });
}
