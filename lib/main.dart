import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const BmiCalculatorPage(),
    );
  }
}

class BmiCalculatorPage extends StatefulWidget {
  const BmiCalculatorPage({super.key});

  @override
  State<BmiCalculatorPage> createState() => _BmiCalculatorPageState();
}

class _BmiCalculatorPageState extends State<BmiCalculatorPage> {
  // Controladores de texto
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Estados da aplicação
  String _selectedGender = 'Masculino'; // 'Masculino' ou 'Feminino'
  bool _hasResult = false;
  double _bmiResult = 0.0;
  String _bmiClassification = '';

  /// Função para calcular o IMC convertendo cm para metros
  void _calculateBMI() {
    if (!_formKey.currentState!.validate()) return;

    final double? weight = double.tryParse(
      _weightController.text.replaceAll(',', '.'),
    );
    final double? heightCm = double.tryParse(
      _heightController.text.replaceAll(',', '.'),
    );

    // Validação de segurança (Prevenção de erros)
    if (weight == null || heightCm == null || weight <= 0 || heightCm <= 0) {
      return;
    }

    // Convertendo altura de cm para metros
    final double heightMeters = heightCm / 100;

    setState(() {
      _bmiResult = weight / (heightMeters * heightMeters);

      if (_bmiResult < 18.5) {
        _bmiClassification = 'Abaixo do peso';
      } else if (_bmiResult >= 18.5 && _bmiResult < 25) {
        _bmiClassification = 'Peso Normal';
      } else if (_bmiResult >= 25 && _bmiResult < 30) {
        _bmiClassification = 'Sobrepeso';
      } else {
        _bmiClassification = 'Obesidade';
      }

      _hasResult = true;
    });
  }

  /// Reseta o estado para calcular novamente
  void _resetAll() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _hasResult = false;
    });
  }

  /// Exibe a aba inferior com as categorias
  void _showCategoriesModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Categorias de IMC',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildCategoryRow('Menor que 18,5', 'você está abaixo do peso.'),
              _buildCategoryRow('18,5 a 24,9', 'seu peso é normal.'),
              _buildCategoryRow('25 a 29,9', 'você está com sobrepeso.'),
              _buildCategoryRow('30 ou mais', 'obesidade.'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.grey,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar estilo protótipo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          'Seu corpo',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: _showCategoriesModal,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Calculadora de IMC',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),

                // Seleção de Gênero (Masculino / Feminino)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => _selectedGender = 'Masculino'),
                      child: Opacity(
                        opacity: _selectedGender == 'Masculino' ? 1.0 : 0.3,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blue[100],
                              child: const Icon(
                                Icons.man,
                                size: 50,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Masculino',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _selectedGender = 'Feminino'),
                      child: Opacity(
                        opacity: _selectedGender == 'Feminino' ? 1.0 : 0.3,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.pink[100],
                              child: const Icon(
                                Icons.woman,
                                size: 50,
                                color: Colors.pink,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Feminino',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Inputs de Peso e Altura lado a lado
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Seu peso (kg)',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextFormField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Obrigatório' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Sua altura (cm)',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextFormField(
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Obrigatório' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Alternância de Estados baseada na variável _hasResult
                if (!_hasResult) ...[
                  // Botão de Calcular
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _calculateBMI,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3498db),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Calcular seu IMC',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Layout de Resultado
                  Center(
                    child: Column(
                      children: [
                        const Divider(thickness: 1),
                        const SizedBox(height: 12),
                        Text(
                          'Seu IMC',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _bmiResult
                              .toStringAsFixed(1)
                              .replaceAll(
                                '.',
                                ',',
                              ), // Troca ponto por vírgula no resultado visual
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _bmiClassification,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: _resetAll,
                          child: const Text(
                            'Calcular IMC novamente',
                            style: TextStyle(
                              color: Color(0xff16a085),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
