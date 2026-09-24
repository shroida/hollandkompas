import 'package:flutter_test/flutter_test.dart';

import 'auth_error_utils.dart';

void main() {
  group('friendlyAuthErrorMessage', () {
    test('maps each known Supabase error message to friendly text', () {
      expect(
        friendlyAuthErrorMessage('Invalid login credentials'),
        'Incorrect email or password.',
      );
      expect(
        friendlyAuthErrorMessage('Email not confirmed'),
        'Please verify your email before logging in.',
      );
      expect(
        friendlyAuthErrorMessage('User not found'),
        'No account exists with this email.',
      );
      expect(
        friendlyAuthErrorMessage('Too many requests'),
        'Too many login attempts. Please try again later.',
      );
    });

    test('matching is case-insensitive, since Supabase\'s casing can vary', () {
      expect(
        friendlyAuthErrorMessage('INVALID LOGIN CREDENTIALS'),
        'Incorrect email or password.',
      );
    });

    test(
      'an unrecognized message passes through unchanged rather than being hidden',
      () {
        expect(
          friendlyAuthErrorMessage('Some brand new Supabase error string'),
          'Some brand new Supabase error string',
        );
      },
    );
  });
}
