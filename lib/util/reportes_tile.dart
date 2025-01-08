import 'package:flutter/material.dart';

class ReportesvTile extends StatelessWidget {
  final String reportesvInicio;
  final String reportesvDescrip;
  final String reportesvImg;
  final reportesvColor;

  final double borderRadius = 12;

  const ReportesvTile({
    super.key,
    required this.reportesvInicio,
    required this.reportesvDescrip,
    required this.reportesvImg,
    required this.reportesvColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: reportesvColor[50],
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
                      color: reportesvColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      reportesvInicio,
                      style: TextStyle(
                        color: reportesvColor[100],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),

              //tipo
              Text(reportesvDescrip),

              //imagen
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Image.asset(reportesvImg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
