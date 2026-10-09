import 'package:flutter/material.dart';
import 'package:flutter_projetomarcel/cadastro_page.dart';
import 'package:flutter_projetomarcel/models/anuncio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Anuncio> _lista = [];

  Future<void> _adicionarAnuncio() async {
    Anuncio? novoAnuncio = await Navigator.push<Anuncio>(
      context,
      MaterialPageRoute(builder: (context) => CadastroPage()),
    );

    if (novoAnuncio != null) {
      setState(() {
        _lista.add(novoAnuncio);
      });
    }
  }

  Future<void> _editarAnuncio(int position) async {
    final item = _lista[position];

    Anuncio? anuncioEditado = await Navigator.push<Anuncio>(
      context,
      MaterialPageRoute(builder: (context) => CadastroPage(anuncio: item)),
    );

    if (anuncioEditado != null) {
      setState(() {
        _lista[position] = anuncioEditado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink[200]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/perfil.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sawoo Chu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 42,
              height: 42,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sawoo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Anuncios',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white, size: 30),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: _lista.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Nenhum anúncio cadastrado',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Toque no + para adicionar um anúncio',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: _lista.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, position) {
                Anuncio item = _lista[position];

                return Dismissible(
                  key: ValueKey(item),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      await _editarAnuncio(position);
                      return false;
                    }

                    if (direction == DismissDirection.endToStart) {
                      return true;
                    }

                    return false;
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      setState(() {
                        _lista.removeAt(position);
                      });

                      // Alerta embaixo da Página.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('O Anúncio foi excluido com sucesso'),
                        ),
                      );
                    }
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    tileColor: Colors.white,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.imagem,
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item.titulo,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      item.descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      'R\$ ${item.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () {
                      _editarAnuncio(position);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[200],
        onPressed: _adicionarAnuncio,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
