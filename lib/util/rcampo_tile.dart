import 'package:flutter/material.dart';

class RcampoTile extends StatelessWidget {
  final String rcampoInicio;
  final String rcampoDescrip;
  final String rcampoImg;
  final rcampoColor;

  final double borderRadius = 12;

  const RcampoTile({
    super.key,
    required this.rcampoInicio,
    required this.rcampoDescrip,
    required this.rcampoImg,
    required this.rcampoColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: rcampoColor[50],
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
                      color: rcampoColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      rcampoInicio,
                      style: TextStyle(
                        color: rcampoColor[100],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),

              //tipo
              Text(rcampoDescrip),

              //imagen
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Image.asset(rcampoImg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
