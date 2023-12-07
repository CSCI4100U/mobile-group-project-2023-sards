import 'dart:convert' show jsonDecode;

import 'package:flutter_quill/flutter_quill.dart' show Document;

String deltaJsonToString(String json){
  return Document.fromJson(jsonDecode(json)).toPlainText();
}

