import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageConstants {
  static final storage = GetStorage();

  static const String token = "token";
  static const String hasLogin = "hasLoginBefore";
  static const String google2faEnable = "google2faEnable";
  static const String locale = "locale";
  static const String userInfo = "userInfo";

  static const localeName = "localeName";

  static const String customBrightness = "customBrightness";
  static const String isDarkMode = "isDarkMode";

  dynamic localeGet() {
    return storage.read(localeName);
  }

  Future<void> localePut(String languageCode) async {
    await storage.write(StorageConstants.localeName, languageCode);
  }

  Locale localizationLocalOrDevice() {
    if (localeGet() != null) {
      return Locale(localeGet().toString());
    } else {
      localePut(Get.deviceLocale!.languageCode);

      return Locale(localeGet().toString());
    }
  }
}
