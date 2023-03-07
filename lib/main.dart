import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.initFlutter();
  await Hive.openBox("mybox");
  runApp(const MaterialApp(
    home: HiveDemo(),
  ));
}

class HiveDemo extends StatefulWidget {
  const HiveDemo({Key? key}) : super(key: key);

  @override
  State<HiveDemo> createState() => _HiveDemoState();
}

class _HiveDemoState extends State<HiveDemo> {
  List<Map<String, dynamic>> items = []; // for store data from hive box
  var box = Hive.box("myBox"); // object creation of hive

  @override
  void initState() {
    super.initState();
    refreshItem();
  }

  void refreshItem() {
    var items = box.keys.map((key) {
      final value = box.get(key);
      return {"key": key, "name": value["name"], "quantity": value["quantity"]};
    }).toList();

    setState(() {
      items = items.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Demo"),
      ),
      body: items.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final current_item = items[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: current_item["name"],
                    // fetching a single key value pair from the list
                    subtitle: current_item["quantity"],
                    trailing: Wrap(
                      children: [
                        IconButton(
                          onPressed: () {
                            _showForm(context, current_item['key']);
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteItem(current_item["key"]);
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showForm(context, null), child: Icon(Icons.add)),
    );
  }

  final name_controller = TextEditingController();
  final quantity_controller = TextEditingController();

  _showForm(BuildContext context, int? itemkey) async {
    if (itemkey != null) {
      final existing_data =
          items.firstWhere((element) => element['key'] == itemkey);
      name_controller.text = existing_data["name"];
      quantity_controller.text = existing_data["quantity"];
    }
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: name_controller,
                  decoration: InputDecoration(hintText: "name"),
                ),
                TextField(
                  controller: quantity_controller,
                  decoration: InputDecoration(hintText: "quantity"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (itemkey == null) {
                      await createItem({
                        "name": name_controller.text,
                        "quantity": quantity_controller.text,
                      });
                    }
                    if (itemkey != null) {
                      await updateItem(itemkey, {
                        "name": name_controller.text.trim(),
                        "quantity": quantity_controller.text.trim(),
                      });
                    }
                    name_controller.text = "";
                    quantity_controller.text = "";
                    Navigator.of(context).pop();
                  },
                  child: Text(itemkey == null ? "Create New" : "Update"),
                ),
              ],
            ),
          );
        });
  }

  Future<void> createItem(Map<String, dynamic> newItem) async {
    await box.add(newItem);
    refreshItem();
  }

  updateItem(int itemkey, Map<String, String> map) {}

  void deleteItem(current_item) {}
}
