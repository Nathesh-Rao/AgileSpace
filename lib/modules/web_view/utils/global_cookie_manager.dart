import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class GlobalCookie {
  GlobalCookie._();

  static final CookieManager manager = CookieManager.instance();

  static Future<void> clearAll() async {
    await manager.deleteAllCookies();
    debugPrint("GlobalCookie => clearAll DONE");
  }
}
