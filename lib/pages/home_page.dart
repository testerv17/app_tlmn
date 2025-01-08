import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_menu/pages/tab/despacho_tab.dart';
import 'package:test_menu/pages/tab/evidencias_tab.dart';
import 'package:test_menu/pages/tab/rcampo_tab.dart';
import 'package:test_menu/pages/tab/reporte_tab.dart';
import 'package:test_menu/pages/tab/reportes_tab.dart';
import 'package:test_menu/util/my_tab.dart';

class HomePage extends StatefulWidget {
  final User user;
  final String role;

  const HomePage({super.key, required this.user, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Widget> myTabs;
  late List<Widget> tabViews;

  @override
  void initState() {
    super.initState();

    if (widget.role == 'admin') {
      myTabs = [
        MyTab(iconPath: 'lib/icons/alm1.png'),
        MyTab(iconPath: 'lib/icons/evid.png'),
        MyTab(iconPath: 'lib/icons/rep2.png'),
        MyTab(iconPath: 'lib/icons/gps2.png'),
      ];
      tabViews = [
        DespachoTab(),
        EvidenciasTab(),
        ReportesTab(),
        RcampoTab(),
      ];
    } else if (widget.role == 'cuadrilla') {
      myTabs = [
        MyTab(iconPath: 'lib/icons/evid.png'),
        MyTab(iconPath: 'lib/icons/gps2.png'),
      ];
      tabViews = [
        EvidenciasTab(),
        RcampoTab(),
      ];
    } else {
      myTabs = [];
      tabViews = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.grey[800], size: 36),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.person, color: Colors.grey[800], size: 36),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 18.0),
              child: Row(
                children: [
                  Text('TrabajoCampo  ', style: TextStyle(fontSize: 20)),
                  Text(
                    'TecnoLuminus',
                    style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 24, 172, 115)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TabBar(tabs: myTabs),
            Expanded(
              child: TabBarView(children: tabViews),
            ),
          ],
        ),
      ),
    );
  }
}
