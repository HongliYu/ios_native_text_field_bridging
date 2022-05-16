import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const searchBarChannel = MethodChannel("com.justetf.justetf/search_bar");

Function? searchBarOnChangeNativeCallback;
Function? searchBarTextFieldShouldBeginEditingCallback;
Function? searchBarTextFieldShouldEndEditingCallback;
Function? searchBarTextFieldShouldDidEndEditCallback;
Function? searchBarTextFieldShouldReturnCallback;

class NativeCode {
  // Flutter => Native
  static Future<String> setSearchBarTextFieldPlaceHolder(
      String placeHolder) async {
    final searchBarTextFieldPlaceHolder = await searchBarChannel.invokeMethod(
      "setSearchBarTextFieldPlaceHolder",
      {"placeholder": placeHolder},
    );
    return searchBarTextFieldPlaceHolder;
  }

  static Future<String> setSearchBarText(String text) async {
    final searchBarText = await searchBarChannel.invokeMethod(
      "setSearchBarText",
      {"text": text},
    );
    return searchBarText;
  }

  static Future<void> setFocus(bool isFocus) async {
    await searchBarChannel.invokeMethod(
      "setFocusSearchBar",
      {"isFocus": isFocus},
    );
  }

  // Native => Flutter
  static registerMethodToNativeCode() {
    searchBarChannel.setMethodCallHandler(iosNativeCodeCallbacks);
  }

  static Future<dynamic> iosNativeCodeCallbacks(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'ios_native_textFieldDidChange':
        debugPrint(
            "ios_native_textFieldDidChange called: ${methodCall.arguments}");
        searchBarOnChangeNativeCallback?.call(methodCall.arguments);
        break;
      case 'ios_native_textFieldEditingDidEnd':
        debugPrint(
            "ios_native_textFieldEditingDidEnd called: ${methodCall.arguments}");
        searchBarTextFieldShouldDidEndEditCallback?.call(methodCall.arguments);
        break;
      case 'ios_native_textFieldShouldReturn':
        debugPrint(
            "ios_native_textFieldShouldReturn called: ${methodCall.arguments}");
        searchBarTextFieldShouldReturnCallback?.call(methodCall.arguments);
        break;
      case 'ios_native_textFieldShouldBeginEditing':
        debugPrint(
            "ios_native_textFieldShouldBeginEditing called: ${methodCall.arguments}");
        searchBarTextFieldShouldBeginEditingCallback
            ?.call(methodCall.arguments);
        break;
      case 'ios_native_textFieldShouldEndEditing':
        debugPrint(
            "ios_native_textFieldShouldEndEditing called: ${methodCall.arguments}");
        searchBarTextFieldShouldEndEditingCallback?.call(methodCall.arguments);
        break;
      default:
    }
  }
}
