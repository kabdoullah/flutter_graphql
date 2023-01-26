import 'package:flutter/material.dart';
import 'package:flutter_graphql_crud/services/queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateTodoScreen extends StatelessWidget {
  UpdateTodoScreen({super.key});
  final TextEditingController editTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Todo"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Column(
          children: [
            const Text(
              "Update Todo",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 60,
            ),
            TextField(
              controller: editTitleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  label: const Text("Title")),
            ),
            const SizedBox(
              height: 10,
            ),
            Mutation(
              options: MutationOptions(
                document: gql(updateTodo),
                onCompleted: (data) {
                  print("data  $data");
                },
                // ignore: void_checks
                update: (cache, result) {
                  return cache;
                },
              ),
              builder: (runMutation, result) {
                return ElevatedButton(
                  onPressed: () {
                    runMutation({
                      "id": 1,
                      "input": {
                        "title": editTitleController.text,
                        "completed": false
                      }
                    });
                    Navigator.pop(context);
                    print("result   : $result");
                  },
                  child: const Text("Update"),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
