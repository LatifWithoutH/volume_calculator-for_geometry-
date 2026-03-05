import 'package:flutter/material.dart';
import 'dart:math';
import '../helpers/format_helper.dart';
import '../services/prefs_service.dart';

class KubusPage extends StatefulWidget {
  const KubusPage({super.key});

  @override
  State<KubusPage> createState() => _KubusPageState();
}

class _KubusPageState extends State<KubusPage> {
  final _controller = TextEditingController();
  
  String _inputUnit = 'cm';
  String _outputUnit = 'cm³';
  String _result = '';
  bool _isLoading = true;

  final List<String> _outputOptions = ['mm³', 'cm³', 'm³', 'liter', 'ml'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final input = await PrefsService.getInputUnit();
    final output = await PrefsService.getOutputUnit();
    setState(() {
      _inputUnit = input;
      _outputUnit = output;
      _isLoading = false;
    });
  }

  Future<void> _changeOutputUnit(String? newUnit) async {
    if (newUnit != null) {
      await PrefsService.setOutputUnit(newUnit);
      setState(() => _outputUnit = newUnit);
      // Jika ada hasil sebelumnya, hitung ulang dengan unit baru
      if (_controller.text.isNotEmpty) _calculate();
    }
  }

  void _calculate() {
    if (_controller.text.isEmpty) {
      setState(() => _result = '❌ Kolom tidak boleh kosong!');
      return;
    }
    
    final input = double.tryParse(_controller.text.replaceAll(',', '.'));
    if (input == null || input <= 0) {
      setState(() => _result = '❌ Masukkan angka yang valid!');
      return;
    }

    // 1. Konversi input ke cm
    final sisiCm = keCm3(input, _inputUnit);
    // 2. Hitung volume dalam cm³
    final volumeCm3 = pow(sisiCm, 3).toDouble();
    // 3. Konversi ke unit output
    final formatted = dariCm3(volumeCm3, _outputUnit);
    final label = getLabelUnit(_outputUnit);

    setState(() => _result = '✅ Volume Kubus: $formatted $label');
  }

  void _reset() {
    _controller.clear();
    setState(() => _result = '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('🔲 Volume Kubus')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('🔲', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Panjang Sisi ($_inputUnit)',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.straighten),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _reset,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // DROPDOWN OUTPUT UNIT
            Card(
              child: DropdownButtonFormField<String>(
                value: _outputUnit,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                  labelText: 'Hasil dalam:',
                  prefixIcon: Icon(Icons.output),
                ),
                items: _outputOptions.map((unit) {
                  return DropdownMenuItem(value: unit, child: Text(getLabelUnit(unit)));
                }).toList(),
                onChanged: _changeOutputUnit,
              ),
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
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Text(_result, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}