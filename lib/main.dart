import 'package:flutter/material.dart';
import 'dart:math';

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
            
            // Card Kubus
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
            
            // Card Tabung
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
            
            // Card Bola
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
    required String emoji,  // ✅ Ganti dari IconData ke String
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
              // ✅ Pakai Text emoji, bukan Icon
              Text(emoji, style: TextStyle(fontSize: 48)),
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
  String _result = '';

  void _calculate() {
    final sisi = double.tryParse(_controller.text);
    if (sisi == null || sisi <= 0) {
      setState(() => _result = '❌ Masukkan angka yang valid!');
      return;
    }
    final volume = pow(sisi, 3);
    setState(() => _result = '✅ Volume Kubus: ${volume.toStringAsFixed(2)} cm³');
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
            // ✅ Emoji besar sebagai visual
            const Text('🔲', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Panjang Sisi (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
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

// ==================== TABUNG PAGE ====================
class TabungPage extends StatefulWidget {
  const TabungPage({super.key});

  @override
  State<TabungPage> createState() => _TabungPageState();
}

class _TabungPageState extends State<TabungPage> {
  final _radiusController = TextEditingController();
  final _heightController = TextEditingController();
  String _result = '';

  void _calculate() {
    final r = double.tryParse(_radiusController.text);
    final h = double.tryParse(_heightController.text);
    if (r == null || h == null || r <= 0 || h <= 0) {
      setState(() => _result = '❌ Masukkan angka yang valid!');
      return;
    }
    final volume = pi * pow(r, 2) * h;
    setState(() => _result = '✅ Volume Tabung: ${volume.toStringAsFixed(2)} cm³');
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
                labelText: 'Radius (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.circle),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tinggi (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height),
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
  String _result = '';

  void _calculate() {
    final r = double.tryParse(_controller.text);
    if (r == null || r <= 0) {
      setState(() => _result = '❌ Masukkan angka yang valid!');
      return;
    }
    final volume = (4 / 3) * pi * pow(r, 3);
    setState(() => _result = '✅ Volume Bola: ${volume.toStringAsFixed(2)} cm³');
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
                labelText: 'Radius (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.circle),
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
