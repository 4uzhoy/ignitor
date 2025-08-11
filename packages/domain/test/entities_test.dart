import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('Entities', () {
    test('add and retrieve entity', () {
      final entities = Entities<User>(entities: []);
      final user = User(id: '1', name: 'John Doe', email: 'john@example.com');
      entities.add(user);

      expect(entities.length, equals(1));
      expect(entities[0], equals(user));
      expect(entities.getById('1'), equals(user));
    });

    test('remove entity', () {
      final user = User(id: '1', name: 'Jane');
      final entities = Entities<User>(entities: [user]);

      entities.remove(user);

      expect(entities.isEmpty, isTrue);
      expect(entities.getById('1'), isNull);
    });
  });
}

