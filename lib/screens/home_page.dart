import 'package:flutter/material.dart';
import 'package:whatsapp/controller.dart';
import 'package:whatsapp/models/contato.dart';
import 'package:whatsapp/screens/aba_contatos.dart';
import 'package:whatsapp/screens/aba_conversas.dart';
import 'package:whatsapp/screens/configuracoes.dart';
import 'package:whatsapp/screens/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.contato});

  final Contato contato;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final Controller _controller = Controller();
  late TabController _tabController;

  void _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Deslogar":
        _controller.deslogarUsuario();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => Login(
                    contato: widget.contato,
                  )),
        );
        break;
      case "Configurações":
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Configuracoes()))
            .then((_) {
          setState(() {
            _controller.recuperarContatos();
          });
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(),
        automaticallyImplyLeading: false,
        backgroundColor: const AppBarTheme().backgroundColor,
        title: const Text(
          'Whatsapp',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return _controller.itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              })
        ],
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.white,
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          tabs: const <Widget>[
            Tab(
              child: Text(
                'Conversas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Contatos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        AbaConversas(
          contato: widget.contato,
        ),
        AbaContatos(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
