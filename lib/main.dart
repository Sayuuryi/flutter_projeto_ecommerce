import 'package:flutter/material.dart';
import 'package:flutter_projetomarcel/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Sawoo Anuncios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: HomePage(),
    ),
  );
}
