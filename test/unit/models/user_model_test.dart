import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/auth/data/models/user_model.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('UserModel.fromJson', () {
    test('maps a student profile correctly', () {
      final model = UserModel.fromJson(profileJson(level: 'a1', role: 'student'));

      expect(model.level, DutchLevel.a1);
      expect(model.role, UserRole.student);
      expect(model.firstName, 'Mohamed');
    });

    test('maps an admin profile correctly', () {
      final model = UserModel.fromJson(profileJson(role: 'admin'));

      expect(model.role, UserRole.admin);
    });

    test('an unknown level value throws rather than silently defaulting', () {
      // DutchLevel.values.byName() throws on an unrecognized name — this
      // test exists so that if someone "fixes" it to silently fall back
      // instead, the test suite notices the behavior changed.
      expect(
        () => UserModel.fromJson(profileJson(level: 'not-a-real-level')),
        throwsArgumentError,
      );
    });
  });

  group('UserModel.toJson', () {
    test('round-trips through fromJson/toJson without losing data', () {
      final original = profileJson();
      final model = UserModel.fromJson(original);
      final json = model.toJson();

      expect(json['id'], original['id']);
      expect(json['email'], original['email']);
      expect(json['level'], original['level']);
      expect(json['role'], original['role']);
    });
  });
}
