import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

Future<void> enterBrowserFullscreen() async {
  final element = web.document.documentElement;

  if (element == null) {
    return;
  }

  await element.requestFullscreen().toDart;
}

Future<void> exitBrowserFullscreen() async {
  if (web.document.fullscreenElement != null) {
    await web.document.exitFullscreen().toDart;
  }
}

bool get isBrowserFullscreen {
  return web.document.fullscreenElement != null;
}

void Function()? listenBrowserFullscreenChange(
  void Function(bool isFullscreen) callback,
) {
  late JSFunction listener;

  listener = (() {
    callback(web.document.fullscreenElement != null);
  }).toJS;

  web.document.addEventListener('fullscreenchange', listener);

  return () {
    web.document.removeEventListener('fullscreenchange', listener);
  };
}
