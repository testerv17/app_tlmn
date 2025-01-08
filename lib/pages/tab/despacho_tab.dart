import 'package:flutter/material.dart';
import 'package:test_menu/pages/almacen_mat.dart';
import 'package:test_menu/pages/despacho_mat.dart';
import 'package:test_menu/util/despacho_tile.dart';
import 'package:test_menu/pages/despacho_mat.dart'; // Import MaterialStorageScreen

class DespachoTab extends StatelessWidget {
  final List despachoat = [
    ["Despacho", "Mat", Colors.red, "lib/images/caja2.png"],
    ["Almacen", "Control", Colors.blue, "lib/images/cajas.png"],
  ];

  DespachoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: despachoat.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (despachoat[index][0] == "Despacho") {
              // Navigate to MaterialStorageScreen when "Despacho" is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MaterialStorageScreen(),
                ),
              );
            } else if (despachoat[index][0] == "Almacen") {
              // Navigate to ReportesPage when "Almacen" is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportesPage(),
                ),
              );
            }
          },
          child: DespachoTile(
            despachoInicio: despachoat[index][0],
            despachoDescrip: despachoat[index][1],
            despachoColor: despachoat[index][2],
            despachoImg: despachoat[index][3],
          ),
        );
      },
    );
  }
}
