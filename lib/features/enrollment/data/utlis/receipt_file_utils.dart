String getFileExtension(String fileName) {
  final trimmedFileName = fileName.trim();

  if (trimmedFileName.isEmpty) {
    return 'jpg';
  }

  final parts = trimmedFileName.split('.');

  if (parts.length < 2 || parts.last.isEmpty) {
    return 'jpg';
  }

  return parts.last.toLowerCase();
}

String getContentType(String extension) {
  switch (extension.toLowerCase()) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'webp':
      return 'image/webp';
    case 'gif':
      return 'image/gif';
    default:
      return 'application/octet-stream';
  }
}
