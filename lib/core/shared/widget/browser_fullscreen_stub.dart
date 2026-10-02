Future<void> enterBrowserFullscreen() async {}

Future<void> exitBrowserFullscreen() async {}

bool get isBrowserFullscreen => false;

void Function()? listenBrowserFullscreenChange(
  void Function(bool isFullscreen) callback,
) {
  return null;
}
