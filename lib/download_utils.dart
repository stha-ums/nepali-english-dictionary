import 'dart:io' as io;

import 'package:flutter/foundation.dart';

Future<io.File> downloadFile(String url, String filename) async {
  var httpClient = new io.HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);

  io.File file = new io.File(filename);
  await file.writeAsBytes(bytes);
  return file;
}