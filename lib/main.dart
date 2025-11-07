import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    GetMaterialApp(
      title: "Application",
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Poppins'),

      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
