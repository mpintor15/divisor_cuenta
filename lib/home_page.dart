import 'package:flutter/material.dart';

import 'models.dart';

String money(double v) => '\$${v.toStringAsFixed(2)}';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bill = Bill();

  Future<void> _addPerson() async {
    final name = await _askText('Nueva persona', 'Nombre');
    if (name == null || name.isEmpty) return;
    setState(() => bill.people.add(name));
  }

  Future<String?> _askText(String title, String label) {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: c,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: label),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, c.text.trim()),
              child: const Text('Agregar')),
        ],
      ),
    );
  }

  Future<void> _editItem({Item? existing}) async {
    if (bill.people.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Primero agrega a las personas')));
      return;
    }
    final nameC = TextEditingController(text: existing?.name ?? '');
    final priceC = TextEditingController(
        text: existing == null ? '' : existing.price.toStringAsFixed(2));
    final eaters = {...?existing?.eaters};
    if (existing == null) eaters.addAll(List.generate(bill.people.length, (i) => i));

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text(existing == null ? 'Nuevo ítem' : 'Editar ítem'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: nameC,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: priceC,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    const InputDecoration(labelText: 'Precio', prefixText: '\$ '),
              ),
              const SizedBox(height: 16),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('¿Quién lo consumió?')),
              Wrap(
                spacing: 8,
                children: [
                  for (var i = 0; i < bill.people.length; i++)
                    FilterChip(
                      label: Text(bill.people[i]),
                      selected: eaters.contains(i),
                      onSelected: (s) =>
                          setD(() => s ? eaters.add(i) : eaters.remove(i)),
                    ),
                ],
              ),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                final p = double.tryParse(priceC.text.replaceAll(',', '.'));
                if (p == null || p <= 0 || eaters.isEmpty) return;
                Navigator.pop(ctx, true);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final price = double.parse(priceC.text.replaceAll(',', '.'));
    final name = nameC.text.trim().isEmpty ? 'Ítem' : nameC.text.trim();
    setState(() {
      if (existing == null) {
        bill.items.add(Item(name: name, price: price, eaters: eaters));
      } else {
        existing
          ..name = name
          ..price = price
          ..eaters = eaters;
      }
    });
  }

  void _clear() => setState(() {
        bill.items.clear();
        bill.people.clear();
      });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Divisor de Cuenta'),
        actions: [
          IconButton(
            tooltip: 'Reiniciar',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: bill.people.isEmpty && bill.items.isEmpty ? null : _clear,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editItem(),
        icon: const Icon(Icons.add),
        label: const Text('Ítem'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          _section('Personas'),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (var i = 0; i < bill.people.length; i++)
                InputChip(
                  avatar: CircleAvatar(child: Text(bill.people[i][0].toUpperCase())),
                  label: Text(bill.people[i]),
                  onDeleted: () => setState(() => bill.removePerson(i)),
                ),
              ActionChip(
                avatar: const Icon(Icons.person_add_alt_1, size: 18),
                label: const Text('Agregar'),
                onPressed: _addPerson,
              ),
            ],
          ),
          _section('Ítems'),
          if (bill.items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('Aún no hay ítems.'),
            ),
          for (final item in bill.items)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(item.eaters.length == bill.people.length
                    ? 'Todos'
                    : (item.eaters.toList()..sort())
                        .map((i) => bill.people[i])
                        .join(', ')),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(money(item.price),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => bill.items.remove(item)),
                  ),
                ]),
                onTap: () => _editItem(existing: item),
              ),
            ),
          _section('Impuesto y propina'),
          _slider('IVA', bill.taxPercent, 0, 25,
              (v) => setState(() => bill.taxPercent = v)),
          _slider('Propina', bill.tipPercent, 0, 30,
              (v) => setState(() => bill.tipPercent = v)),
          _section('Total por persona'),
          if (bill.people.isEmpty || bill.items.isEmpty)
            const Text('Agrega personas e ítems para ver el resultado.')
          else ...[
            for (var i = 0; i < bill.people.length; i++)
              Card(
                color: cs.primaryContainer,
                child: ListTile(
                  title: Text(bill.people[i]),
                  subtitle: Text(
                      'Consumo ${money(bill.subtotalOf(i))} + IVA ${money(bill.taxOf(i))} + propina ${money(bill.tipOf(i))}'),
                  trailing: Text(money(bill.totalOf(i)),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
            const Divider(height: 32),
            _row('Subtotal', bill.subtotal),
            _row('IVA (${bill.taxPercent.round()}%)', bill.tax),
            _row('Propina (${bill.tipPercent.round()}%)', bill.tip),
            _row('Total', bill.total, bold: true),
          ],
        ],
      ),
    );
  }

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(t,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
      );

  Widget _slider(String label, double v, double min, double max,
          ValueChanged<double> onChanged) =>
      Row(children: [
        SizedBox(width: 72, child: Text(label)),
        Expanded(
          child: Slider(
            value: v,
            min: min,
            max: max,
            divisions: (max - min).round(),
            label: '${v.round()}%',
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 44, child: Text('${v.round()}%')),
      ]);

  Widget _row(String l, double v, {bool bold = false}) {
    final style = TextStyle(
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontSize: bold ? 18 : 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(l, style: style), Text(money(v), style: style)],
      ),
    );
  }
}
