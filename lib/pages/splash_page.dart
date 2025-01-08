import 'package:flutter/material.dart';
import 'package:test_menu/pages/loginv2.dart';
import 'package:test_menu/util/colors.dart';

class SlashScreen extends StatelessWidget {
  const SlashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: backgroundColor1,
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.53,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    color: primaryColor,
                    image: DecorationImage(
                        image: AssetImage(
                      "lib/images/tt.png",
                    ))),
              ),
            ),
            Positioned(
                top: size.height * 0.6,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "TecnoLuminus",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: textcolor1,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "Aplicación para control de Almacen\nDespacho Materiales,Reportes Campo\ny Evidencias Campo",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          color: textcolor2,
                        ),
                      ),
                      SizedBox(height: size.height * 0.07),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                        ),
                        child: Container(
                          height: size.height * 0.08,
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: backgroundColor3.withOpacity(0.9),
                              border: Border.all(
                                color: Colors.white,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withOpacity(0.05),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(0, -1),
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Row(
                              children: [
                                Container(
                                  height: size.height * 0.8,
                                  width: size.width / 2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Inicia",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: textcolor1,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginvTwo(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Ingresar",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: textcolor1,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
