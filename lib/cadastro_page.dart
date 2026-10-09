import 'package:flutter/material.dart';
import 'package:flutter_projetomarcel/models/anuncio.dart';
import 'package:flutter/services.dart';

class CadastroPage extends StatefulWidget {
  final Anuncio? anuncio;

  CadastroPage({super.key, this.anuncio});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _imagens = [
    'assets/images/fone.jpg',
    'assets/images/relogio.jpg',
    'assets/images/tenis.jpg',
  ];

  String _imagemSelecionada = 'assets/images/fone.jpg';

  @override
  void initState() {
    super.initState();

    if (widget.anuncio != null) {
      _tituloController.text = widget.anuncio!.titulo;
      _descricaoController.text = widget.anuncio!.descricao;
      _precoController.text = widget.anuncio!.preco.toString();

      _imagemSelecionada = widget.anuncio!.imagem;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();

    super.dispose();
  }

  void _cadastrar() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      final novoAnuncio = Anuncio(
        _tituloController.text.trim(),
        _descricaoController.text.trim(),
        double.parse(_precoController.text.replaceAll(',', '.')),
        imagem: _imagemSelecionada,
      );

      Navigator.pop(context, novoAnuncio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: Text(
          widget.anuncio == null ? 'Novo anúncio' : 'Editar anúncio',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Escolha uma imagem',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 12),

              Wrap(
                spacing: 12,
                children: _imagens.map((imagem) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _imagemSelecionada = imagem;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _imagemSelecionada == imagem
                              ? Colors.pink
                              : Colors.grey,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        imagem,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 25),

              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título do anúncio',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o título do anúncio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite a descrição';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _precoController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                ],
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Preço (R\$)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o preço';
                  }

                  if (value.contains(',') && value.contains('.')) {
                    return 'Use apenas vírgula ou ponto';
                  }

                  if (value.split(RegExp(r'[,.]')).length > 2) {
                    return 'Preço inválido';
                  }

                  double? preco = double.tryParse(value.replaceAll(',', '.'));

                  if (preco == null || preco < 0) {
                    return 'Digite um preço válido';
                  }

                  return null;
                },
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _cadastrar,
                      child: Text('Salvar'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
