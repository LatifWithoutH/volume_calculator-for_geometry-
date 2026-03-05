import 'package:flutter/material.dart';
import '../services/prefs_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _inputUnit = 'cm';
  bool _isLoading = true;

  final List<Map<String, String>> _inputOptions = [
    {'value': 'mm', 'label': 'Milimeter (mm)'},
    {'value': 'cm', 'label': 'Centimeter (cm)'},
    {'value': 'm', 'label': 'Meter (m)'},
    {'value': 'liter', 'label': 'Liter (L)'},
    {'value': 'ml', 'label': 'Mililiter (mL)'},
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final input = await PrefsService.getInputUnit();
    setState(() {
      _inputUnit = input;
      _isLoading = false;
    });
  }

  Future<void> _saveInput(String? value) async {
    if (value != null) {
      await PrefsService.setInputUnit(value);
      setState(() => _inputUnit = value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Satuan Input diubah ke: $value'), duration: const Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Satuan Input Default',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Satuan ini akan digunakan di semua halaman kalkulator.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            Card(
              child: DropdownButtonFormField<String>(
                value: _inputUnit,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                  labelText: 'Pilih Satuan Input',
                ),
                items: _inputOptions.map((opt) {
                  return DropdownMenuItem(value: opt['value'], child: Text(opt['label']!));
                }).toList(),
                onChanged: _saveInput,
              ),
            ),
            
            const Spacer(),
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  await PrefsService.setInputUnit('cm');
                  await PrefsService.setOutputUnit('cm³');
                  _loadPreferences();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('🔄 Pengaturan direset ke default')),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset ke Default'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}