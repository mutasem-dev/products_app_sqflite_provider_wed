import 'dart:io';

import 'package:flutter/material.dart';
import 'package:products_app/ProductsPage.dart';
import 'package:products_app/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  
  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DatabaseProvider.instance,
      builder: (context, child) => MaterialApp(
        home: Productspage(),
      ),
      );
  }
}