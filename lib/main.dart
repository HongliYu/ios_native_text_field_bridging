import 'package:flutter/material.dart';
import 'package:ios_native_text_field_bridging/ios_native_text_field.dart';
import 'package:ios_native_text_field_bridging/native_code.dart';
import 'package:flutter/services.dart';

void main() {
  _setupApp();
}

_setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  NativeCode.registerMethodToNativeCode();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'iOS native bridging demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: const [
            Text(
              "Input:",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              width: 200,
              height: 32,
              child: IOSNativeTextField(placeholder: "Place holder"),
            ),
          ],
        ),
      ),
    );
  }
}
