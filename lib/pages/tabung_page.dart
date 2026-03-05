import 'package:flutter/material.dart';
import 'dart:math';
import '../helpers/format_helper.dart';
import '../services/prefs_service.dart';

class TabungPage extends StatefulWidget {
  const TabungPage({super.key});

  @override
  State<TabungPage> createState() => _TabungPageState();
}

class _TabungPageState extends State<TabungPage> {
  final _radiusController = TextEditingController();
  final _heightController = TextEditingController();
  
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
      if (_radiusController.text.isNotEmpty && _heightController.text.isNotEmpty) _calculate();
    }
  }

  void _calculate() {
    if (_radiusController.text.isEmpty || _heightController.text.isEmpty) {
      setState(() => _result = '❌ Kolom tidak boleh kosong!');
      return;
    }
    
    final rInput = double.tryParse(_radiusController.text.replaceAll(',', '.'));
    final hInput = double.tryParse(_heightController.text.replaceAll(',', '.'));
    
    if (rInput == null || hInput == null || rInput <= 0 || hInput <= 0) {
      setState(() => _result = '❌ Masukkan angka yang valid!');
      return;
    }

    final rCm = keCm3(rInput, _inputUnit);
    final hCm = keCm3(hInput, _inputUnit);
    final volumeCm3 = (pi * pow(rCm, 2) * hCm).toDouble();
    
    final formatted = dariCm3(volumeCm3, _outputUnit);
    final label = getLabelUnit(_outputUnit);

    setState(() => _result = '✅ Volume Tabung: $formatted $label');
  }

  void _reset() {
    _radiusController.clear();
    _heightController.clear();
    setState(() => _result = '');
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('🛢️ Volume Tabung')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('🛢️', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            
            TextField(
              controller: _radiusController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Radius ($_inputUnit)',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.circle),
                suffixIcon: IconButton(icon: const Icon(Icons.clear), onPressed: _reset),
              ),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tinggi ($_inputUnit)',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.height),
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
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),
            const SizedBox(height: 24),
            
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(_result, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}