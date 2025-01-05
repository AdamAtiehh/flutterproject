import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'edit.dart';

class ViewMember extends StatefulWidget {
  const ViewMember({super.key});

  @override
  State<ViewMember> createState() => _ViewMemberState();
}

class _ViewMemberState extends State<ViewMember> {
  List admindata = [];

  Future<void> delrecord(int id) async {
    String url = "https://aqua-stingray-882847.hostingersite.com/delete.php";

    var res = await http.post(Uri.parse(url), body: {"id": id.toString()});

    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      if (response["status"] == "success") {
        getrecord(); // Refresh the data after deletion
      }
    }
  }

  Future<void> getrecord() async {
    String url = "https://aqua-stingray-882847.hostingersite.com/view.php";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);

      setState(() {
        admindata =
            decodedResponse is Map ? [decodedResponse] : decodedResponse;
      });
    }
  }

  @override
  void initState() {
    getrecord();
    super.initState();
  }

  void showAdminInfoDialog(int id, String name, String password, String role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Admin Information",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ID: $id",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Name: $name",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Password: $password",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Role: $role",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "View Members",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: admindata.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: admindata.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      onTap: () {
                        showAdminInfoDialog(
                          int.parse(admindata[index]["id"]),
                          admindata[index]["name"],
                          admindata[index]["password"],
                          admindata[index]["role"],
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: const Icon(
                          CupertinoIcons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        admindata[index]["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        "Role: ${admindata[index]["role"]}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Edit(
                                    admindata[index]["id"],
                                    admindata[index]["name"],
                                    admindata[index]["password"],
                                    admindata[index]["role"],
                                  ),
                                ),
                              ).then((value) {
                                if (value == true) {
                                  getrecord();
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              delrecord(int.parse(admindata[index]["id"]));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
