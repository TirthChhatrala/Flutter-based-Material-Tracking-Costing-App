import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      child: const MyApp(),
    ),
  );
}

class AppData extends ChangeNotifier {
  String _userRole = 'Operator';
  final List<MaterialItem> _materials = [
    MaterialItem(
        id: 'M1',
        name: 'Steel',
        unitCost: 10.0,
        unitType: 'kg',
        stock: 50,
        qrCode: 'QR1'),
    MaterialItem(
        id: 'M2',
        name: 'Aluminum',
        unitCost: 5.0,
        unitType: 'kg',
        stock: 100,
        qrCode: 'QR2'),
  ];
  final List<ProductionLog> _productionLogs = [];
  final List<User> _users = [
    User(username: 'admin', role: 'Admin'),
    User(username: 'operator', role: 'Operator'),
  ];

  String get userRole => _userRole;

  List<MaterialItem> get materials => _materials;

  List<ProductionLog> get productionLogs => _productionLogs;

  List<User> get users => _users;

  void setUserRole(String role) {
    _userRole = role;
    notifyListeners();
  }

  void addMaterial(MaterialItem material) {
    _materials.add(material);
    notifyListeners();
  }

  void updateMaterial(MaterialItem updatedMaterial) {
    final index = _materials.indexWhere((material) => material.id == updatedMaterial.id);
    if (index != -1) {
      _materials[index] = updatedMaterial;
      notifyListeners();
    }
  }

  void deleteMaterial(String materialId) {
    _materials.removeWhere((material) => material.id == materialId);
    notifyListeners();
  }

  void logMaterialUsage(String materialId, double quantityUsed) {
    final material = _materials.firstWhere((material) => material.id == materialId);
    if (material.stock >= quantityUsed) {
      material.stock -= quantityUsed;
      _productionLogs.add(ProductionLog(
          materialId: materialId,
          quantityUsed: quantityUsed,
          timestamp: DateTime.now()));
      notifyListeners();
    } else {
      // Handle insufficient stock (e.g., show a message)
      print('Insufficient stock for material ${material.name}');
    }
  }

  double calculateRawMaterialCost(String materialId, double quantityUsed) {
    final material = _materials.firstWhere((material) => material.id == materialId);
    return material.unitCost * quantityUsed;
  }

  double calculateManufacturingCost(String materialId, double quantityUsed, double additionalProcessingCosts) {
    final rawMaterialCost = calculateRawMaterialCost(materialId, quantityUsed);
    return rawMaterialCost + additionalProcessingCosts;
  }

  double calculateFinalProductPrice(String materialId, double quantityUsed, double additionalProcessingCosts, double desiredMargin) {
    final manufacturingCost = calculateManufacturingCost(materialId, quantityUsed, additionalProcessingCosts);
    return manufacturingCost + desiredMargin;
  }
}

class MaterialItem {
  MaterialItem({
    required this.id,
    required this.name,
    required this.unitCost,
    required this.unitType,
    required this.stock,
    required this.qrCode,
  });

  String id;
  String name;
  double unitCost;
  String unitType;
  double stock;
  String qrCode;
}

class ProductionLog {
  ProductionLog({
    required this.materialId,
    required this.quantityUsed,
    required this.timestamp,
  });

  String materialId;
  double quantityUsed;
  DateTime timestamp;
}

class User {
  User({required this.username, required this.role});

  String username;
  String role;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartFab Industries',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: const TextStyle(color: Colors.grey),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      home: const RoleSelectionScreen(),
    );
  }
}

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Role'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Provider.of<AppData>(context, listen: false).setUserRole('Admin');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('Admin'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Provider.of<AppData>(context, listen: false).setUserRole('Operator');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('Operator'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('SmartFab - ${appData.userRole}'),
      ),
      body: appData.userRole == 'Admin' ? const AdminDashboard() : const OperatorDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Admin Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageMaterialsScreen()),
              );
            },
            child: const Text('Manage Materials'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductionLogsScreen()),
              );
            },
            child: const Text('View Production Logs'),
          ),
        ],
      ),
    );
  }
}

class OperatorDashboard extends StatelessWidget {
  const OperatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Operator Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScanMaterialScreen()),
              );
            },
            child: const Text('Scan Material'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductionLogsScreen()),
              );
            },
            child: const Text('View Production Logs'),
          ),
        ],
      ),
    );
  }
}

class ManageMaterialsScreen extends StatefulWidget {
  const ManageMaterialsScreen({super.key});

  @override
  State<ManageMaterialsScreen> createState() => _ManageMaterialsScreenState();
}

class _ManageMaterialsScreenState extends State<ManageMaterialsScreen> {
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Materials'),
      ),
      body: appData.materials.isEmpty
          ? const Center(
              child: Text('No materials found. Add some!'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: appData.materials.length,
              itemBuilder: (context, index) {
                final material = appData.materials[index];
                return MaterialCard(material: material);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMaterialScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MaterialCard extends StatelessWidget {
  const MaterialCard({super.key, required this.material});

  final MaterialItem material;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(material.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('ID: ${material.id}'),
            Text('Unit Cost: \$${material.unitCost}/${material.unitType}'),
            Text('Stock: ${material.stock} ${material.unitType}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditMaterialScreen(material: material),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text('Are you sure you want to delete this material?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Provider.of<AppData>(context, listen: false).deleteMaterial(material.id);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddMaterialScreen extends StatefulWidget {
  const AddMaterialScreen({super.key});

  @override
  State<AddMaterialScreen> createState() => _AddMaterialScreenState();
}

class _AddMaterialScreenState extends State<AddMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _unitCostController = TextEditingController();
  final _unitTypeController = TextEditingController();
  final _stockController = TextEditingController();
  final _qrCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Material'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _unitCostController,
                decoration: const InputDecoration(labelText: 'Unit Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit cost';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _unitTypeController,
                decoration: const InputDecoration(labelText: 'Unit Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a stock quantity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _qrCodeController,
                decoration: const InputDecoration(labelText: 'QR Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a QR Code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newMaterial = MaterialItem(
                      id: _idController.text,
                      name: _nameController.text,
                      unitCost: double.parse(_unitCostController.text),
                      unitType: _unitTypeController.text,
                      stock: double.parse(_stockController.text),
                      qrCode: _qrCodeController.text,
                    );
                    Provider.of<AppData>(context, listen: false).addMaterial(newMaterial);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditMaterialScreen extends StatefulWidget {
  const EditMaterialScreen({super.key, required this.material});

  final MaterialItem material;

  @override
  State<EditMaterialScreen> createState() => _EditMaterialScreenState();
}

class _EditMaterialScreenState extends State<EditMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _unitCostController;
  late final TextEditingController _unitTypeController;
  late final TextEditingController _stockController;
  late final TextEditingController _qrCodeController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.material.id);
    _nameController = TextEditingController(text: widget.material.name);
    _unitCostController = TextEditingController(text: widget.material.unitCost.toString());
    _unitTypeController = TextEditingController(text: widget.material.unitType);
    _stockController = TextEditingController(text: widget.material.stock.toString());
    _qrCodeController = TextEditingController(text: widget.material.qrCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Material'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID'),
                enabled: false,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _unitCostController,
                decoration: const InputDecoration(labelText: 'Unit Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit cost';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _unitTypeController,
                decoration: const InputDecoration(labelText: 'Unit Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a stock quantity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _qrCodeController,
                decoration: const InputDecoration(labelText: 'QR Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a QR Code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedMaterial = MaterialItem(
                      id: _idController.text,
                      name: _nameController.text,
                      unitCost: double.parse(_unitCostController.text),
                      unitType: _unitTypeController.text,
                      stock: double.parse(_stockController.text),
                      qrCode: _qrCodeController.text,
                    );
                    Provider.of<AppData>(context, listen: false).updateMaterial(updatedMaterial);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScanMaterialScreen extends StatefulWidget {
  const ScanMaterialScreen({super.key});

  @override
  State<ScanMaterialScreen> createState() => _ScanMaterialScreenState();
}

class _ScanMaterialScreenState extends State<ScanMaterialScreen> {
  String _scannedCode = '';
  double _quantityUsed = 0;

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final material = appData.materials.firstWhere((m) => m.qrCode == _scannedCode,
        orElse: () => MaterialItem(id: '', name: '', unitCost: 0, unitType: '', stock: 0, qrCode: ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Material'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Simulate scanning a QR code
                setState(() {
                  _scannedCode = 'QR1'; // Simulate scanning QR1
                });
              },
              child: const Text('Simulate Scan QR Code'),
            ),
            const SizedBox(height: 10),
            Text('Scanned Code: $_scannedCode', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            if (material.id.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Material: ${material.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Stock: ${material.stock} ${material.unitType}'),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantity Used'),
                    onChanged: (value) {
                      setState(() {
                        _quantityUsed = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_quantityUsed > 0) {
                        Provider.of<AppData>(context, listen: false).logMaterialUsage(material.id, _quantityUsed);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Material usage logged')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid quantity')),
                        );
                      }
                    },
                    child: const Text('Log Usage'),
                  ),
                ],
              )
            else
              const Text('No material found for this QR code.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class ProductionLogsScreen extends StatelessWidget {
  const ProductionLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final logs = appData.productionLogs;
    final materials = appData.materials;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Logs'),
      ),
      body: logs.isEmpty
          ? const Center(child: Text('No production logs available.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final material = materials.firstWhere((m) => m.id == log.materialId);
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Material: ${material.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Quantity Used: ${log.quantityUsed} ${material.unitType}'),
                        Text('Timestamp: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp)}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}