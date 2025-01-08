import 'package:flutter/material.dart';
import 'package:test_menu/pages/evidencia_mat.dart';
import 'package:test_menu/util/evidencias_tile.dart';

class EvidenciasTab extends StatelessWidget {
  final List evidenciaat = [
    ["Evidencias", "Campo", Colors.teal, "lib/images/galeria.png"],
    //["Almacen", "Control", Colors.blue, "lib/images/cajas.png"],
  ];

  EvidenciasTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: evidenciaat.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (evidenciaat[index][0] == "Evidencias") {
              // Navigate to MaterialStorageScreen when "evidencia" is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EvidenceScreen(),
                ),
              );
            }
          },
          child: EvidenciaTile(
            evidenciaInicio: evidenciaat[index][0],
            evidenciaDescrip: evidenciaat[index][1],
            evidenciaColor: evidenciaat[index][2],
            evidenciaImg: evidenciaat[index][3],
          ),
        );
      },
    );
  }
}
