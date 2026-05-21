# 🧮 Calculadora de IMC em Flutter

Este projeto é uma aplicação mobile moderna desenvolvida em **Flutter** utilizando a linguagem **Dart**. O objetivo principal é calcular o Índice de Massa Corporal (IMC) de forma dinâmica, garantindo uma experiência de usuário fluida e livre de falhas de entrada de dados.

Atividade desenvolvida como parte da formação em tecnologia e desenvolvimento mobile.

---

## 🚀 Funcionalidades

*   **Cálculo em Tempo Real:** Insira seu peso e sua altura para obter o valor exato do IMC instantaneamente.
*   **Classificação Automática:** Exibe a categoria do IMC (Abaixo do peso, Peso ideal, Obesidade, etc.) de acordo com os padrões da Organização Mundial da Saúde (OMS).
*   **Tratamento de Erros Robusto:** Prevenção total contra divisão por zero, campos vazios ou caracteres inválidos.
*   **Adaptação Regional:** Suporta nativamente a digitação de números com ponto (`1.75`) ou vírgula (`1,75`), evitando quebras no aplicativo.
*   **Reset Rápido:** Botão na barra superior para limpar todos os campos e estados com um único clique.

---

## 🛠️ Aspectos Técnicos Destacados

### 1. Gerenciamento de Estado com `StatefulWidget`
Para permitir que o resultado do cálculo seja renderizado dinamicamente sem a necessidade de mudar de tela, a interface faz uso do ciclo de vida de um `StatefulWidget`. A mágica acontece através do método:
```dart
setState(() {
  _resultadoTexto = "Seu IMC é: ...";
  _classificacaoTexto = classificacao;
});