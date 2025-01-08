import 'package:flutter/material.dart';

class DespachoTile extends StatelessWidget {
  final String despachoInicio;
  final String despachoDescrip;
  final String despachoImg;
  final despachoColor;

  final double borderRadius = 12;

  const DespachoTile({
    super.key,
    required this.despachoInicio,
    required this.despachoDescrip,
    required this.despachoImg,
    required this.despachoColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: despachoColor[50],
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
                      color: despachoColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      despachoInicio,
                      style: TextStyle(
                        color: despachoColor[100],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),

              //tipo
              Text(despachoDescrip),

              //imagen
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Image.asset(despachoImg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
