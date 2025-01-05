import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Edit extends StatefulWidget {
  final String id;
  final String name;
  final String password;
  final String role;

  const Edit(this.id, this.name, this.password, this.role, {super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  Future<void> updaterecord() async {
    String url = "https://aqua-stingray-882847.hostingersite.com/edit.php";

    // Send a POST request with updated data
    var res = await http.post(Uri.parse(url), body: {
      "id": widget.id,
      "name": nameController.text,
      "password": passwordController.text,
      "role": roleController.text,
    });

    // Check the response from the server
    if (res.body.isNotEmpty) {
      var response = jsonDecode(res.body);
      if (response["success"] == true) {
        Navigator.pop(context, true); // Close screen and signal update success
      } else {
        print("Update failed: ${response["message"]}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill text controllers with existing data
    nameController.text = widget.name;
    passwordController.text = widget.password;
    roleController.text = widget.role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Admin"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: const TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: roleController,
                decoration: InputDecoration(
                  labelText: "Role",
                  labelStyle: const TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: updaterecord,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    const Text("Update Admin", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
