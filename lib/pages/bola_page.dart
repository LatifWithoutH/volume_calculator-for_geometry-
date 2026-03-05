import 'package:flutter/material.dart';
import 'dart:math';
import '../helpers/format_helper.dart';

class BolaPage extends StatefulWidget {
  const BolaPage({super.key});

  @override
  State<BolaPage> createState() => _BolaPageState();
}

class _BolaPageState extends State<BolaPage> {
  final _controller = TextEditingController();
  String _selectedUnit = 'cm';
  String _result = '';

  void _calculate() {
    if (_controller.text.isEmpty) {
      setState(() => _result = '❌ Kolom tidak boleh kosong!');
      return;
    }
    
    final rInput = double.tryParse(_controller.text.replaceAll(',', '.'));
    if (rInput == null || rInput <= 0) {
      setState(() => _result = '❌ Masukkan angka yang valid!');
      return;
    }

    final rCm = _selectedUnit == 'm' ? rInput * 100 : rInput;
    final volumeCm3 = ((4 / 3) * pi * pow(rCm, 3)).toDouble();
    
    final outputUnit = '${_selectedUnit}³';
    final volumeFinal = konversiVolume(volumeCm3, outputUnit);
    final formatted = formatAngkaIndonesia(volumeFinal);

    setState(() => _result = '✅ Volume Bola: $formatted $outputUnit');
  }

  void _reset() {
    _controller.clear();
    setState(() {
      _result = '';
      _selectedUnit = 'cm';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚽ Volume Bola')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('⚽', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Radius',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.circle),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _reset,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Satuan: '),
                DropdownButton<String>(
                  value: _selectedUnit,
                  items: const [
                    DropdownMenuItem(value: 'cm', child: Text('Centimeter (cm)')),
                    DropdownMenuItem(value: 'm', child: Text('Meter (m)')),
                  ],
                  onChanged: (val) => setState(() => _selectedUnit = val!),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _calculate,
              icon: const Icon(Icons.calculate),
              label: const Text('Hitung Volume'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 24),
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Text(_result, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}
