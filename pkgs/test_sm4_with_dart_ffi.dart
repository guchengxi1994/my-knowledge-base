import 'package:ffi/ffi.dart';
import 'dart:ffi';
import 'dart:io' show Directory;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

abstract class BaseEncrypt {
  String encode(String s);

  String decode(String s);

  void init();
}

class SM4 extends BaseEncrypt {
  String key;
  SM4({required this.key});

  DynamicLibrary? _dylib;

  @override
  void init() {
    if (TaichiDevUtils.isWindows) {
      String dllPath = path.join(Directory.current.path, "sm4.dll");
      _dylib = DynamicLibrary.open(dllPath);
    } else {
      // ignore: avoid_print
      print("platform not supported now");
    }
  }

  @override
  String decode(String s) {
    if (_dylib != null) {
      final Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>) nativeEncode =
          _dylib!
              .lookup<
                  NativeFunction<
                      Pointer<Utf8> Function(
                          Pointer<Utf8>, Pointer<Utf8>)>>("CBCDecode")
              .asFunction();
      final keyP = key.toNativeUtf8();
      var sP = s.toNativeUtf8();
      String decodeStr = nativeEncode(keyP, sP).toDartString();
      return decodeStr;
    }
    return "";
  }

  @override
  String encode(String s) {
    if (_dylib != null) {
      final Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>) nativeEncode =
          _dylib!
              .lookup<
                  NativeFunction<
                      Pointer<Utf8> Function(
                          Pointer<Utf8>, Pointer<Utf8>)>>("CBCEncode")
              .asFunction();
      final keyP = key.toNativeUtf8();
      var sP = s.toNativeUtf8();
      String encodeStr = nativeEncode(keyP, sP).toDartString();
      return encodeStr;
    }
    return "";
  }
}

void main(List<String> args) {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _controller,
          ),
          ElevatedButton(
              onPressed: () {
                SM4 _sm4 = SM4(key: "qwertyasdfgh1234")..init();
                String s = _sm4.encode(_controller.text);
                debugPrint(s);
              },
              child: const Text("加密")),
          ElevatedButton(
              onPressed: () {
                SM4 _sm4 = SM4(key: "qwertyasdfgh1234")..init();
                String s = _sm4.decode(_controller.text);
                debugPrint(s);
              },
              child: const Text("解密")),
          ElevatedButton(
              onPressed: () {
                debugPrint(Directory.current.path);
              },
              child: const Text("current path"))
        ],
      ),
    );
  }
}
