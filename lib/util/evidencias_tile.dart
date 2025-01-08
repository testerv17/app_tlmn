import 'package:flutter/material.dart';

class EvidenciaTile extends StatelessWidget {
  final String evidenciaInicio;
  final String evidenciaDescrip;
  final String evidenciaImg;
  final evidenciaColor;

  final double borderRadius = 12;

  const EvidenciaTile({
    super.key,
    required this.evidenciaInicio,
    required this.evidenciaDescrip,
    required this.evidenciaImg,
    required this.evidenciaColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: evidenciaColor[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              //descripcion
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: evidenciaColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      evidenciaInicio,
                      style: TextStyle(
                        color: evidenciaColor[100],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),

              //tipo
              Text(evidenciaDescrip),

              //imagen
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Image.asset(evidenciaImg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
