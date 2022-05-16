import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IOSNativeTextField extends StatefulWidget {
  final String? placeholder;

  const IOSNativeTextField({
    this.placeholder,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => IOSNativeTextFieldState();
}

class IOSNativeTextFieldState extends State<IOSNativeTextField> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return UiKitView(
      viewType: 'NativeSearchBarTextField',
      creationParams: {
        "left": 4,
        "top": 0,
        "unfocusedWidth": screenWidth - 120,
        "focusedWidth": screenWidth - 100,
        "height": 28,
        "backgroundColor": 0xFFEEEEEE,
        "placeholder": widget.placeholder,
        "placeholderColor": 0xFF777777,
        "textStyle": const {
          "fontFamily": "OpenSans-Regular",
          "color": 0xFF444444,
          "fontSize": 16.0,
        }
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
