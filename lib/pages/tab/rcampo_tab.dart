import 'package:flutter/material.dart';

import 'package:test_menu/pages/reportes_mat.dart';
import 'package:test_menu/util/rcampo_tile.dart';

class RcampoTab extends StatelessWidget {
  final List rcampovv = [
    ["RCampo", "Campo", Colors.indigoAccent, "lib/images/gps.png"],
    //["Almacen", "Control", Colors.blue, "lib/images/cajas.png"],
  ];

  RcampoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: rcampovv.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (rcampovv[index][0] == "RCampo") {
              // Navigate to MaterialStorageScreen when "evidencia" is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Reportesv(),
                ),
              );
            }
          },
          child: RcampoTile(
            rcampoInicio: rcampovv[index][0],
            rcampoDescrip: rcampovv[index][1],
            rcampoColor: rcampovv[index][2],
            rcampoImg: rcampovv[index][3],
          ),
        );
      },
    );
  }
}
