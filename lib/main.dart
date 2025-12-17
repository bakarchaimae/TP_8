import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';
import 'helloUI.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContractLinking(),
      child: MaterialApp(
        title: "Hello World DApp",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.tealAccent,
        ),
        home: const HelloUI(),
      ),
    );
  }
}
