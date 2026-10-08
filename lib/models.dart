class Item {
  Item({required this.name, required this.price, required this.eaters});

  String name;
  double price;
  Set<int> eaters; // indices into the people list
}

class Bill {
  final List<String> people = [];
  final List<Item> items = [];
  double taxPercent = 15;
  double tipPercent = 10;

  double get subtotal => items.fold(0.0, (s, i) => s + i.price);
  double get tax => subtotal * taxPercent / 100;
  double get tip => subtotal * tipPercent / 100;
  double get total => subtotal + tax + tip;

  /// Per-person subtotal before tax and tip.
  double subtotalOf(int person) {
    var sum = 0.0;
    for (final item in items) {
      if (item.eaters.contains(person)) sum += item.price / item.eaters.length;
    }
    return sum;
  }

  double taxOf(int person) => subtotalOf(person) * taxPercent / 100;
  double tipOf(int person) => subtotalOf(person) * tipPercent / 100;
  double totalOf(int person) =>
      subtotalOf(person) + taxOf(person) + tipOf(person);

  void removePerson(int index) {
    people.removeAt(index);
    for (final item in items) {
      item.eaters = {
        for (final e in item.eaters)
          if (e != index) e > index ? e - 1 : e,
      };
    }
    items.removeWhere((i) => i.eaters.isEmpty);
  }
}
