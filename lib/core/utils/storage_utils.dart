import 'package:axpert_space/common/app_snackbar/app_snackbar.dart';
import 'package:file_downloader_flutter/file_downloader_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../config/config.dart';

class StorageUtils {
  static Future<void> downloadFile_inAppWebView({
    required InAppWebViewController controller,
    required DownloadStartRequest downloadStartRequest,
    void Function(String? path)? onDownloadComplete,
    void Function(String? error)? onDownloadError,
  }) async {
    debugPrint(
        "downloadFile_inAppWebView started: ${downloadStartRequest.url}");
    if (downloadStartRequest.url.toString().startsWith("blob")) {
      debugPrint("Blob data");
      // String alertCode = "alert('" + downloadStartRequest.url.toString() + "')";
      String yourCode =
          "window.URL.revokeObjectURL('${downloadStartRequest.url}');";

      final String functionBody = "var xhr = new XMLHttpRequest();\n"
          "console.log(\"Working\");\n"
          "var blobUrl ='${downloadStartRequest.url.toString()}';\n"
          "console.log(blobUrl);\n"
          "xhr.open('GET', blobUrl, true);\n"
          "console.log(\"Opened...\");\n"
          "xhr.responseType = 'blob';\n"
          "console.log(this.status);\n"
          "xhr.onload = function(e) {\n"
          "if (this.status == 200) {\n"
          "var blob = this.response;\n"
          "var reader = new FileReader();\n"
          "reader.readAsDataURL(blob);\n"
          "reader.onloadend = function() {\n"
          "var base64data = reader.result;\n"
          "console.log(base64data);\n"
          "var base64ContentArray = base64data.split(\",\");\n"
          // "var mimeType = base64ContentArray[0].match(/[^:\s*]\w+\/[\w-+\d.]+(?=[;| ])/)[0];\n"
          "var decodedFile = base64ContentArray[1];\n"
          "console.log('pdf');\n"
          "window.flutter_inappwebview.callHandler('blobToBase64Handler', decodedFile, 'pdf');\n"
          " };\n"
          "};\n"
          "};\n"
          "xhr.send();";
      // print(functionBody);
      await controller.evaluateJavascript(source: yourCode).then((result) {
        // print(result?.value.runtimeType); // int
        // print(result?.error.runtimeType); // Null
        debugPrint(result.toString());
        _download(downloadStartRequest.url.toString(), onDownloadComplete,
            onDownloadError);
      });
      // {value: 49, error: null}
    } else {
      _download(downloadStartRequest.url.toString(), onDownloadComplete,
          onDownloadError);
    }
  }

  static void _download(String url, void Function(String? path)? onComplete,
      void Function(String? error)? onDownloadError) async {
    try {
      debugPrint("download Url: $url");
      String fname = url.split('/').last.split('.').first;
      // fname = fname.replaceAll(RegExp(r'%20'), ' ');

      fname = Uri.decodeFull(fname);
      debugPrint("download FileName: $fname");

      var path =
          await FileDownloaderFlutter().urlFileSaver(url: url, fileName: fname);

      if (onComplete != null) {
        onComplete(path);
      }
      if (path != null) {
        _showDownloadSnackBar(message: "File downloaded to $path");
      }
    } catch (e) {
      if (onDownloadError != null) {
        onDownloadError(e.toString());
      }
      AppSnackBar.showError("Something went wrong", "");

      debugPrint("Download error: ${e.toString()}");
    }
  }

  static Future<void> _showDownloadSnackBar(
      {required String message, bool isError = false}) async {
    Get.showSnackbar(GetSnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: !isError
          ? AppColors.chipCardWidgetColorGreen
          : AppColors.chipCardWidgetColorRed,
      icon: Icon(!isError ? Icons.check_circle : Icons.error),
      title: !isError ? "Success" : "Failed",
      message: message,
    ));
  }
}
