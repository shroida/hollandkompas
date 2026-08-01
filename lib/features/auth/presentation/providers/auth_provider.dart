import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
String appName(Ref ref) {
  return 'HollandKompas';
}