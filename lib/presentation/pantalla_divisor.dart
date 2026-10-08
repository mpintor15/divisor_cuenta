import 'package:flutter/material.dart';

import 'divisor_controller.dart';

class PantallaDivisor extends StatefulWidget {
  final DivisorController controlador;

  const PantallaDivisor({super.key, required this.controlador});

  @override
  State<PantallaDivisor> createState() => _PantallaDivisorState();
}

class _PantallaDivisorState extends State<PantallaDivisor> {
  final _monto = TextEditingController();
  final _personas = TextEditingController();
  final _propina = TextEditingController();

  @override
  void dispose() {
    _monto.dispose();
    _personas.dispose();
    _propina.dispose();
    super.dispose();
  }

  void _calcular() {
    setState(() {
      widget.controlador.calcular(
        monto: _monto.text,
        personas: _personas.text,
        propina: _propina.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultado = widget.controlador.resultado;
    final error = widget.controlador.error;

    return Scaffold(
      appBar: AppBar(title: const Text('Divisor de cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              key: const Key('monto'),
              controller: _monto,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Monto total'),
            ),
            TextField(
              key: const Key('personas'),
              controller: _personas,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Número de personas'),
            ),
            TextField(
              key: const Key('propina'),
              controller: _propina,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Propina (%)'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _calcular,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 24),
            if (error != null)
              Text(
                error,
                key: const Key('error'),
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            if (resultado != null) ...[
              Text(
                resultado,
                key: const Key('resultado'),
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const Text('por persona', textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
