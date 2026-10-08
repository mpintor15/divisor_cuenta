import 'package:divisor_cuenta/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('splits shared items and applies tax and tip', () {
    final b = Bill()
      ..people.addAll(['Ana', 'Beto'])
      ..taxPercent = 10
      ..tipPercent = 10;
    b.items
      ..add(Item(name: 'Pizza', price: 20, eaters: {0, 1}))
      ..add(Item(name: 'Postre', price: 10, eaters: {1}));
    expect(b.subtotalOf(0), 10);
    expect(b.subtotalOf(1), 20);
    expect(b.totalOf(0), closeTo(12, 1e-9));
    expect(b.totalOf(0) + b.totalOf(1), closeTo(b.total, 1e-9));
  });

  test('removing a person reindexes items', () {
    final b = Bill()..people.addAll(['A', 'B', 'C']);
    b.items.add(Item(name: 'x', price: 9, eaters: {0, 2}));
    b.removePerson(0);
    expect(b.items.single.eaters, {1});
  }
  );
}
