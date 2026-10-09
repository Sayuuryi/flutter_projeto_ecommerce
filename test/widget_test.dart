import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_projetomarcel/home_page.dart';

void main() {
  testWidgets('cadastra uma tarefa', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    expect(find.text('Lista de Tarefas'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Cadastro de Tarefa'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Estudar Flutter');
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    expect(find.text('Estudar Flutter'), findsOneWidget);
  });
}
