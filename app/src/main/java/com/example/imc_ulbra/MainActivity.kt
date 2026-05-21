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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        ),
        home: const ImcCalculatorPage(),
        );
    }
}

class ImcCalculatorPage extends StatefulWidget {
    const ImcCalculatorPage({super.key});

    @override
    State<ImcCalculatorPage> createState() => _ImcCalculatorPageState();
}

class _ImcCalculatorPageState extends State<ImcCalculatorPage> {
    // Controladores para capturar o texto dos inputs
    final TextEditingController _pesoController = TextEditingController();
    final TextEditingController _alturaController = TextEditingController();

    // Chave global para validação do formulário
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    // Variáveis de estado
    String _resultadoTexto = "Informe seus dados para calcular!";
    String _classificacaoTexto = "";

    /// Método responsável por validar as entradas e calcular o IMC
    void _calcularImc() {
        // Verifica se o formulário passou nas validações visuais do TextFormField
        if (!_formKey.currentState!.validate()) {
        return;
    }

        // Substitui vírgula por ponto para evitar erros de parse no Brasil
        final String pesoString = _pesoController.text.replaceAll(',', '.');
        final String alturaString = _alturaController.text.replaceAll(',', '.');

        final double? peso = double.tryParse(pesoString);
        final double? altura = double.tryParse(alturaString);

        // Prevenção de Erros: Garante que os números são válidos e maiores que zero
        if (peso == null || altura == null || altura <= 0 || peso <= 0) {
            setState(() {
                _resultadoTexto = "Valores inválidos!";
                _classificacaoTexto = "Por favor, digite números maiores que zero.";
            });
            return;
        }

        // Aplicação da fórmula: IMC = peso / (altura * altura)
        final double imc = peso / (altura * altura);

        // Define a classificação com base no resultado
        String classificacao = "";
        if (imc < 18.5) {
            classificacao = "Abaixo do peso";
        } else if (imc >= 18.5 && imc < 24.9) {
            classificacao = "Peso ideal (parabéns!)";
        } else if (imc >= 25.0 && imc < 29.9) {
            classificacao = "Levemente acima do peso";
        } else if (imc >= 30.0 && imc < 34.9) {
            classificacao = "Obesidade Grau I";
        } else if (imc >= 35.0 && imc < 39.9) {
            classificacao = "Obesidade Grau II (severa)";
        } else {
            classificacao = "Obesidade Grau III (mórbida)";
        }

        // Atualiza o estado da tela de forma dinâmica
        setState(() {
            _resultadoTexto = "Seu IMC é: ${imc.toStringAsFixed(2)}";
            _classificacaoTexto = classificacao;
        });
    }

    /// Método para resetar todos os campos e o estado da tela
    void _limparCampos() {
        _pesoController.clear();
        _alturaController.clear();
        setState(() {
            _resultadoTexto = "Informe seus dados para calcular!";
            _classificacaoTexto = "";
        });
    }

    @override
    void dispose() {
        // Boa prática: descartar os controladores ao destruir o widget
        _pesoController.dispose();
        _alturaController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                    title: const Text('Calculadora de IMC'),
            centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
        IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _limparCampos,
            tooltip: 'Resetar campos',
        ),
        ],
        ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
        key: _formKey,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        const SizedBox(height: 10),
        const Icon(Icons.scale_rounded, size: 80, color: Colors.teal),
        const SizedBox(height: 20),

        // Input de Peso
        TextFormField(
            controller: _pesoController,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
        ),
        decoration: const InputDecoration(
        labelText: 'Peso (kg)',
        hintText: 'Ex: 75.5',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.fitness_center),
        ),
        validator: (value) {
        if (value == null || value.isEmpty) {
            return 'Por favor, insira seu peso';
        }
        if (double.tryParse(value.replaceAll(',', '.')) == null) {
            return 'Insira um número válido';
        }
        return null;
    },
        ),
        const SizedBox(height: 20),

        // Input de Altura
        TextFormField(
            controller: _alturaController,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
        ),
        decoration: const InputDecoration(
        labelText: 'Altura (m)',
        hintText: 'Ex: 1.75',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.height),
        ),
        validator: (value) {
        if (value == null || value.isEmpty) {
            return 'Por favor, insira sua altura';
        }
        final parsed = double.tryParse(value.replaceAll(',', '.'));
        if (parsed == null) {
            return 'Insira um número válido';
        }
        if (parsed <= 0) {
            return 'A altura deve ser maior que zero';
        }
        return null;
    },
        ),
        const SizedBox(height: 30),

        // Botão de Calcular
        ElevatedButton(
            onPressed: _calcularImc,
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        ),
        ),
        child: const Text('Calcular'),
        ),
        const SizedBox(height: 40),

        // Área de Exibição dos Resultados Dinâmicos
        Card(
            elevation: 4,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
        children: [
        Text(
            _resultadoTexto,
            textAlign: TextAlign.center,
        style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        ),
        ),
        if (_classificacaoTexto.isNotEmpty) ...[
        const SizedBox(height: 10),
        Text(
            _classificacaoTexto,
            textAlign: TextAlign.center,
        style: TextStyle(
        fontSize: 18,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w500,
        ),
        ),
        ],
        ],
        ),
        ),
        ),
        ],
        ),
        ),
        ),
        );
    }
}
