import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    test('copyWith updates fields', () {
      final user = User(id: '1', name: 'John');
      final updated = user.copyWith(name: 'Jane');

      expect(updated.name, equals('Jane'));
      expect(updated.id, equals('1'));
    });

    test('equality uses id', () {
      final user1 = User(id: '1', name: 'Alice');
      final user2 = User(id: '1', name: 'Bob');

      expect(user1, equals(user2));
    });
  });
}

