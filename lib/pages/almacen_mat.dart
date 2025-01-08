import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ReportesPage extends StatelessWidget {
  const ReportesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 28, 28, 37),
          title: Row(
            children: [
              // Add image before title
              Image.asset(
                'lib/images/tt.png', // Path to the image
                width: 28,
                height: 28,
              ),
              const SizedBox(width: 10),
              const Text(
                'Reportes',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Navigate back
            },
          ),
          bottom: const TabBar(
            indicatorColor: Color.fromARGB(255, 156, 216, 88),
            tabs: [
              Tab(text: 'Stock'),
              Tab(text: 'Entregado'),
              Tab(text: 'Regresado'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MaterialStockTab(), // Fixed: Removed const
            MaterialDispatchedTab(), // Fixed: Removed const
            MaterialReturnedTab(), // Fixed: Removed const
          ],
        ),
      ),
    );
  }
}

class MaterialStockTab extends StatefulWidget {
  @override
  _MaterialStockTabState createState() => _MaterialStockTabState();
}

class _MaterialStockTabState extends State<MaterialStockTab> {
  final DatabaseReference _adminMaterialRef =
      FirebaseDatabase.instance.ref("ADMIN_MATERIAL");
  List<Map<String, dynamic>> materials = [];
  bool isLoading = true; // For displaying a loading spinner

  @override
  void initState() {
    super.initState();
    _fetchMaterials();
  }

  Future<void> _fetchMaterials() async {
    try {
      debugPrint("Fetching materials from ADMIN_MATERIAL...");

      _adminMaterialRef.onValue.listen((event) {
        final data = event.snapshot.value;

        debugPrint("Raw data from ADMIN_MATERIAL: $data");

        if (data != null && data is List) {
          // Filter out null entries and parse the valid materials
          final fetchedMaterials = data
              .where((item) => item != null) // Exclude null values
              .map((item) {
            final material = Map<String, dynamic>.from(item);
            return {
              "ID": material["ID"]?.toString() ?? "Unknown",
              "Descripcion": material["Descripcion"] ?? "Unknown",
              "CantidadActual": material["CantidadActual"] ?? 0,
              "UM": material["UM"] ?? "N/A",
            };
          }).toList();

          debugPrint("Parsed materials: $fetchedMaterials");

          if (mounted) {
            setState(() {
              materials = fetchedMaterials;
              isLoading = false;
            });
          }
        } else {
          debugPrint("No valid materials found in ADMIN_MATERIAL.");
          if (mounted) {
            setState(() {
              materials = [];
              isLoading = false;
            });
          }
        }
      });
    } catch (error) {
      debugPrint("Error fetching ADMIN_MATERIAL: $error");
      if (mounted) {
        setState(() {
          materials = [];
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : materials.isEmpty
              ? const Center(
                  child: Text(
                    "No materials found in stock.",
                    style: TextStyle(
                        color: Color.fromARGB(179, 22, 20, 20), fontSize: 16),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stock Actual',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: materials.length,
                        itemBuilder: (context, index) {
                          final material = materials[index];
                          return Card(
                            color: const Color.fromARGB(255, 144, 187, 94),
                            child: ListTile(
                              title: Text(
                                'ID: ${material["ID"]}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Descripcion: ${material["Descripcion"]}\n'
                                'Cantidad: ${material["CantidadActual"]}\n'
                                'UM: ${material["UM"]}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

class MaterialDispatchedTab extends StatefulWidget {
  @override
  _MaterialDispatchedTabState createState() => _MaterialDispatchedTabState();
}

class _MaterialDispatchedTabState extends State<MaterialDispatchedTab> {
  final DatabaseReference _cuadrillaMaterialRef =
      FirebaseDatabase.instance.ref("Cuadrilla_Material");
  List<Map<String, dynamic>> dispatchedMaterials = [];

  @override
  void initState() {
    super.initState();
    _fetchDispatchedMaterials();
  }

  Future<void> _fetchDispatchedMaterials() async {
    _cuadrillaMaterialRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map<dynamic, dynamic>) {
        final fetchedMaterials = data.entries.map((entry) {
          final material = Map<String, dynamic>.from(entry.value);
          return {
            "CuadrillaName": material["CuadrillaName"] ?? "Unknown",
            "codigo_recib": material["codigo_recib"] ?? "Unknown",
            "CantidadRecib": material["CantidadRecib"] ?? 0,
            "FechaRecib": material["FechaRecib"] ?? "Unknown",
          };
        }).toList();

        if (mounted) {
          setState(() {
            dispatchedMaterials = fetchedMaterials;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Material Entregado',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: dispatchedMaterials.length,
              itemBuilder: (context, index) {
                final material = dispatchedMaterials[index];
                return Card(
                  color: const Color.fromARGB(255, 187, 94, 94),
                  child: ListTile(
                    title: Text(
                      'Cuadrilla: ${material["CuadrillaName"]}', // Cuadrilla Name
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Codigo: ${material["codigo_recib"]}\n'
                      'Cantidad: ${material["CantidadRecib"]}\n'
                      'Fecha: ${material["FechaRecib"]}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MaterialReturnedTab extends StatefulWidget {
  @override
  _MaterialReturnedTabState createState() => _MaterialReturnedTabState();
}

class _MaterialReturnedTabState extends State<MaterialReturnedTab> {
  final DatabaseReference _cuadrillaRegresoRef =
      FirebaseDatabase.instance.ref("Cuadrilla_regreso");
  List<Map<String, dynamic>> returnedMaterials = [];

  @override
  void initState() {
    super.initState();
    _fetchReturnedMaterials();
  }

  Future<void> _fetchReturnedMaterials() async {
    _cuadrillaRegresoRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map<dynamic, dynamic>) {
        final fetchedMaterials = data.entries.map((entry) {
          final material = Map<String, dynamic>.from(entry.value);
          return {
            "CuadrillaName": material["CuadrillaName"] ?? "Unknown",
            "cod_reg": material["cod_reg"] ?? "Unknown",
            "reg_cant": material["reg_cant"] ?? 0,
            "FechaReg": material["FechaReg"] ?? "Unknown",
          };
        }).toList();

        if (mounted) {
          setState(() {
            returnedMaterials = fetchedMaterials;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Material Regresado',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: returnedMaterials.length,
              itemBuilder: (context, index) {
                final material = returnedMaterials[index];
                return Card(
                  color: const Color.fromARGB(255, 94, 144, 187),
                  child: ListTile(
                    title: Text(
                      'Cuadrilla: ${material["CuadrillaName"]}', // Cuadrilla Name
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Codigo: ${material["cod_reg"]}\n'
                      'Cantidad: ${material["reg_cant"]}\n'
                      'Fecha: ${material["FechaReg"]}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
