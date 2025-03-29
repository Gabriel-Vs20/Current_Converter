import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> opcoes = ["Dólar", "Euro", "Real", "Libra"];
  TextEditingController editingUm = TextEditingController();

  Future<double> getCotacao(String moeda) async {
    String url = "https://economia.awesomeapi.com.br/json/last/$moeda-BRL";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return double.parse(data["${moeda}BRL"]["bid"]);
      } else {
        throw Exception("Falha ao carregar os dados");
      }
    } catch (e) {
      print("Erro: $e");
      return 1.0; // Retorna 1.0 como fallback
    }
  }

  @override
  void initState() {
    super.initState();
    editingUm.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    editingUm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? selecionado;
    String? selecaoUm;
    String? selecaoDois;
    double? preco = 1.0;

    return Scaffold(
      appBar: AppBar(title: Text("Currency Converter")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Selecionar moeda "),
                DropdownButton<String>(
                  hint: selecionado == null ? Text("Escolha") : null,
                  value: selecionado,
                  items: opcoes.map((opcao) {
                    return DropdownMenuItem(
                      value: opcao,
                      child: Text(opcao),
                    );
                  }).toList(),
                  onChanged: (novoValorUm) {
                    setState(() {
                      selecionado = novoValorUm;
                      selecaoUm = novoValorUm;
                      print(selecaoUm);
                    });
                  },
                ),
                SizedBox(
                  height: 40,
                  width: 100,
                  child: TextField(
                    controller: editingUm,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Selecionar moeda "),
                DropdownButton<String>(
                  hint: selecionado == null ? Text("Escolha") : null,
                  value: selecionado,
                  items: opcoes.map((opcao) {
                    return DropdownMenuItem(
                      value: opcao,
                      child: Text(opcao),
                    );
                  }).toList(),
                  onChanged: (novoValorDois) async {
                    setState(() {
                      selecionado = novoValorDois;
                      selecaoDois = novoValorDois;
                      print(
                          selecaoDois); //usando apenas para debugar no terminal e ver o resultado sendo exibido
                    });
                    double novaCotacao = await getCotacao(selecaoDois!);
                    setState(() {
                      preco = novaCotacao;
                      print(preco);
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 40),
                  child: Container(
                    height: 40,
                    width: 100,
                    child: Text(
                      ((double.tryParse(editingUm.text.isEmpty
                                      ? "0"
                                      : editingUm.text) ??
                                  0) *
                              (preco ?? 1.0))
                          .toStringAsFixed(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
