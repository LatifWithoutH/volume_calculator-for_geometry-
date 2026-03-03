import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

// ==================== HELPER FUNCTIONS ====================
String formatAngkaIndonesia(double angka) {
  return NumberFormat('#,##0.##', 'id_ID').format(angka);
}

double konversiVolume(double volumeCm3, String targetUnit) {
  switch (targetUnit) {
    case 'cm³': return volumeCm3;
    case 'm³': return volumeCm3 / 1000000;
    case 'liter': return volumeCm3 / 1000;
    default: return volumeCm3;
  }
}

// ==================== MAIN APP ====================
void main() {
  runApp(const VolumeApp());
}

class VolumeApp extends StatelessWidget {
  const VolumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Volume',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ==================== HOME PAGE ====================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📐 Kalkulator Volume'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pilih Bangun Ruang:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildShapeCard(
              context,
              emoji: '🔲',
              title: 'Kubus',
              subtitle: 'V = s³',
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KubusPage()),
              ),
            ),
            const SizedBox(height: 12),
            _buildShapeCard(
              context,
              emoji: '🛢️',
              title: 'Tabung',
              subtitle: 'V = π × r² × h',
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TabungPage()),
              ),
            ),
            const SizedBox(height: 12),
            _buildShapeCard(
              context,
              emoji: '⚽',
              title: 'Bola',
              subtitle: 'V = 4/3 × π × r³',
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BolaPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShapeCard(BuildContext context, {
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 2),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== KUBUS PAGE ====================
class KubusPage extends StatefulWidget {
  const KubusPage({super.key});

  @override
  State<KubusPage> createState() => _KubusPageState();
}

class _KubusPageState extends State<KubusPage> {
  final _controller = TextEditingController();
  String _selectedUnit = 'cm';
  String _result = '';

  void _calculate() {
    final input = double.tryParse(_controller.text.replaceAll(',', '.'));
    if (input == null || input <= 0) {
      setState(() => _result = '❌ Masukkan angka yang valid!');
      return;
    }

    final sisiCm = _selectedUnit == 'm' ? input * 100 : input;
    final volumeCm3 = pow(sisiCm, 3).toDouble();

    final outputUnit = '${_selectedUnit}³';
    final volumeFinal = konversiVolume(volumeCm3, outputUnit);
    final formatted = formatAngkaIndonesia(volumeFinal);

    setState(() => _result = '✅ Volume Kubus: $formatted $outputUnit');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔲 Volume Kubus')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('🔲', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Panjang Sisi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
                helperText: 'Gunakan titik atau koma untuk desimal',
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

// ==================== TABUNG PAGE ====================
class TabungPage extends StatefulWidget {
  const TabungPage({super.key});

  @override
  State<TabungPage> createState() => _TabungPageState();
}

class _TabungPageState extends State<TabungPage> {
  final _radiusController = TextEditingController();
  final _heightController = TextEditingController();
  String _selectedUnit = 'cm';
  String _result = '';

  void _calculate() {
    final rInput = double.tryParse(_radiusController.text.replaceAll(',', '.'));
    final hInput = double.tryParse(_heightController.text.replaceAll(',', '.'));
    
    if (rInput == null || hInput == null || rInput <= 0 || hInput <= 0) {
      setState(() => _result = '❌ Masukkan angka yang valid!');
      return;
    }

    final rCm = _selectedUnit == 'm' ? rInput * 100 : rInput;
    final hCm = _selectedUnit == 'm' ? hInput * 100 : hInput;
    
    final volumeCm3 = (pi * pow(rCm, 2) * hCm).toDouble();
    final outputUnit = '${_selectedUnit}³';
    final volumeFinal = konversiVolume(volumeCm3, outputUnit);
    final formatted = formatAngkaIndonesia(volumeFinal);

    setState(() => _result = '✅ Volume Tabung: $formatted $outputUnit');
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🛢️ Volume Tabung')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('🛢️', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            TextField(
              controller: _radiusController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Radius',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.circle),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tinggi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height),
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

// ==================== BOLA PAGE ====================
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚽ Volume Bola')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('⚽', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Radius',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.circle),
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
