import 'package:flutter/material.dart';

import 'package:test_menu/pages/reportes_mat.dart';

import 'package:test_menu/util/reportes_tile.dart';

class ReportesTab extends StatelessWidget {
  final List reportesvv = [
    ["Reportes", "Campo", Colors.blueGrey, "lib/images/rep1.png"],
    //["Almacen", "Control", Colors.blue, "lib/images/cajas.png"],
  ];

  ReportesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: reportesvv.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (reportesvv[index][0] == "Reportes") {
              // Navigate to MaterialStorageScreen when "evidencia" is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Reportesv(),
                ),
              );
            }
          },
          child: ReportesvTile(
            reportesvInicio: reportesvv[index][0],
            reportesvDescrip: reportesvv[index][1],
            reportesvColor: reportesvv[index][2],
            reportesvImg: reportesvv[index][3],
          ),
        );
      },
    );
  }
}
