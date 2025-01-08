import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // For formatting timestamps

class MaterialStorageScreen extends StatefulWidget {
  const MaterialStorageScreen({super.key});

  @override
  State<MaterialStorageScreen> createState() => _MaterialStorageScreenState();
}

class _MaterialStorageScreenState extends State<MaterialStorageScreen> {
  final DatabaseReference _adminMaterialRef =
      FirebaseDatabase.instance.ref("ADMIN_MATERIAL");
  final DatabaseReference _cuadrillaMaterialRef =
      FirebaseDatabase.instance.ref("Cuadrilla_Material");

  List<Map<String, dynamic>> stockData = [];
  List<Map<String, dynamic>> selectedMaterials = [];
  String? selectedCuadrilla;
  String? selectedMaterial;
  int? selectedMaterialCode;
  int availableStock = 0;
  final TextEditingController _dispatchQuantityController =
      TextEditingController();

  final List<String> cuadrillas = ["Cuad1", "Cuad2", "Cuad3", "Cuad4"];

  @override
  void initState() {
    super.initState();
    _fetchStockData();
  }

  // Fetch stock data from Firebase
  Future<void> _fetchStockData() async {
    try {
      _adminMaterialRef.onValue.listen((event) {
        final data = event.snapshot.value;

        if (data is List) {
          setState(() {
            stockData = data.asMap().entries.map((entry) {
              final material = entry.value as Map<dynamic, dynamic>? ?? {};
              return {
                "ID": entry.key.toString(),
                "Descripcion":
                    material["Descripcion"]?.toString() ?? "No Description",
                "CantidadActual": material["CantidadActual"] ?? 0,
                "UM": material["UM"]?.toString() ?? "N/A",
              };
            }).toList();
          });
        } else {
          setState(() {
            stockData = [];
          });
        }
      });
    } catch (error, stackTrace) {
      debugPrint("Error fetching stock data: $error");
      debugPrint("Stack trace: $stackTrace");
    }
  }

  // Handle material selection
  void _onMaterialSelected(String? material) {
    if (!mounted) return;

    setState(() {
      selectedMaterial = material;
      final selected = stockData.firstWhere(
        (item) => item["Descripcion"] == material,
        orElse: () => {},
      );
      if (selected.isNotEmpty) {
        selectedMaterialCode = int.tryParse(selected["ID"].toString());
        availableStock = selected["CantidadActual"];
      } else {
        selectedMaterialCode = null;
        availableStock = 0;
      }
    });
  }

  // Add material to the list
  void _addMaterialToOrder() {
    final dispatchQuantity = int.tryParse(_dispatchQuantityController.text);

    if (selectedCuadrilla == null || selectedMaterial == null) {
      _showMessage("Error", "Please select a Cuadrilla and a Material.");
      return;
    }

    if (dispatchQuantity == null || dispatchQuantity <= 0) {
      _showMessage("Error", "Please enter a valid quantity.");
      return;
    }

    if (dispatchQuantity > availableStock) {
      _showMessage("Error", "Insufficient stock for dispatch.");
      return;
    }

    setState(() {
      selectedMaterials.add({
        "CuadrillaName": selectedCuadrilla,
        "codigo_recib": selectedMaterialCode,
        "Descripcion": selectedMaterial,
        "CantidadRecib": dispatchQuantity,
      });
      _clearInputsForNextMaterial();
    });

    _showMessage("Correcto", "Material agregado a la orden.");
  }

  // Dispatch all materials in the order
  Future<void> _dispatchAllMaterials() async {
    if (selectedMaterials.isEmpty) {
      _showMessage("Error", "Material no incluido en orden.");
      return;
    }

    try {
      final String folioNumber =
          DateTime.now().millisecondsSinceEpoch.toString();
      final String timestamp =
          DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

      for (final material in selectedMaterials) {
        // Validate data
        final int? materialCode = material["codigo_recib"];
        final int? quantity = material["CantidadRecib"];

        if (materialCode == null || quantity == null || quantity <= 0) {
          debugPrint("Invalid material data: $material");
          continue;
        }

        // Log dispatch data
        debugPrint("Entregando material: $material");

        // Update Firebase `Cuadrilla_Material`
        try {
          await _cuadrillaMaterialRef.push().set({
            "CuadrillaName": material["CuadrillaName"],
            "codigo_recib": materialCode,
            "CantidadRecib": quantity,
            "folio_recep": folioNumber,
            "FechaRecib": timestamp,
          });
        } catch (error, stackTrace) {
          debugPrint("Error saving dispatch to Cuadrilla_Material: $error");
          debugPrint("Stack trace: $stackTrace");
        }

        // Match `codigo_recib` with `ID` in `ADMIN_MATERIAL` and update stock
        try {
          final adminMaterial = stockData.firstWhere(
            (item) => int.tryParse(item["ID"].toString()) == materialCode,
            orElse: () => {},
          );

          if (adminMaterial.isNotEmpty) {
            final int currentStock = adminMaterial["CantidadActual"] ?? 0;
            final int updatedStock = currentStock - quantity;

            debugPrint(
                "Updating ADMIN_MATERIAL: Codigo: $materialCode, CurrentStock: $currentStock, Dispatched: $quantity, UpdatedStock: $updatedStock");

            // Update ADMIN_MATERIAL in Firebase
            await _adminMaterialRef.child(materialCode.toString()).update({
              "CantidadActual": updatedStock,
            });
          } else {
            debugPrint(
                "Material with ID $materialCode not found in ADMIN_MATERIAL");
          }
        } catch (error, stackTrace) {
          debugPrint("Error updating stock in ADMIN_MATERIAL: $error");
          debugPrint("Stack trace: $stackTrace");
        }
      }

      _showMessage("Correcto", "Material entregado correctamente.");
      _fetchStockData();
      setState(() {
        selectedMaterials.clear();
      });
    } catch (error, stackTrace) {
      debugPrint("Error in dispatchAllMaterials: $error");
      debugPrint("Stack trace: $stackTrace");
      _showMessage("Error", "An error occurred while dispatching materials.");
    }
  }

  void _clearInputsForNextMaterial() {
    setState(() {
      selectedMaterial = null;
      selectedMaterialCode = null;
      availableStock = 0;
      _dispatchQuantityController.clear();
    });
  }

  void _showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 241),
      appBar: AppBar(
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
              'Almacen',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 28, 28, 37),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for Cuadrilla
            const Text(
              "Selecciona Cuadrilla",
              style: TextStyle(
                color: Color.fromARGB(255, 3, 90, 90),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: cuadrillas.contains(selectedCuadrilla)
                  ? selectedCuadrilla
                  : null,
              items: cuadrillas
                  .map((cuadrilla) => DropdownMenuItem<String>(
                        value: cuadrilla,
                        child: Text(
                          cuadrilla,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 3, 90, 90),
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedCuadrilla = value),
              hint: const Text(
                "Selecciona Cuadrilla",
                style: TextStyle(
                  color: Color.fromARGB(255, 3, 90, 90),
                ),
              ),
              dropdownColor: const Color.fromARGB(255, 44, 44, 44),
            ),

            const SizedBox(height: 20),

            // Dropdown for Material
            const Text(
              "Selecciona Material",
              style: TextStyle(
                color: Color.fromARGB(255, 3, 90, 90),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: stockData
                      .any((item) => item["Descripcion"] == selectedMaterial)
                  ? selectedMaterial
                  : null, // Reset if invalid
              items: stockData.map((material) {
                return DropdownMenuItem<String>(
                  value: material["Descripcion"],
                  child: Text(
                    material["Descripcion"],
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: _onMaterialSelected,
              hint: const Text(
                "Selecciona Material",
                style: TextStyle(color: Color.fromARGB(255, 3, 90, 90)),
              ),
              dropdownColor: const Color.fromARGB(255, 44, 44, 44),
            ),

            const SizedBox(height: 20),

            // Dispatch Quantity Input
            TextField(
              controller: _dispatchQuantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Cantidad a Entregar",
                labelStyle:
                    const TextStyle(color: Color.fromARGB(179, 26, 25, 25)),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: const TextStyle(color: Color.fromARGB(255, 3, 90, 90)),
            ),
            const SizedBox(height: 10),

            // Add Material Button
            ElevatedButton(
              onPressed: _addMaterialToOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 82, 194, 129),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                "Agregar Material a Orden",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),

            // Dispatch All Materials Button
            ElevatedButton(
              onPressed: _dispatchAllMaterials,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 102, 102),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                "Entregar",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // List of Selected Materials
            Expanded(
              child: ListView.builder(
                itemCount: selectedMaterials.length,
                itemBuilder: (context, index) {
                  final material = selectedMaterials[index];
                  return Card(
                    color: Color.fromARGB(255, 68, 182, 228),
                    child: ListTile(
                      title: Text(
                        material["Descripcion"],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Quantity: ${material["CantidadRecib"]}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            selectedMaterials.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
