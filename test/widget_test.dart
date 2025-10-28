// This is a basic Flutter widget test for Flappy Bird Physics app.

import 'package:flappy_bird_physics/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlappyBirdPhysicsApp());

    // Wait for the splash screen animation to start
    await tester.pump();

    // Verify that the app title exists
    expect(find.text('Flappy Bird Physics'), findsOneWidget);
  });

  testWidgets('App title is correct', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const FlappyBirdPhysicsApp());

    // Get the MaterialApp widget
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    
    // Verify the app title
    expect(materialApp.title, 'Flappy Bird Physics');
  });
}
