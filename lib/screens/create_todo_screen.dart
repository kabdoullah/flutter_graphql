import 'package:flutter/material.dart';
import 'package:flutter_graphql_crud/services/queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({super.key});

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Todo"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create Todo",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 60,
            ),
            TextField(
              controller: titleController,
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
                document: gql(createTodo),
                update: (cache, result) {
                  return cache;
                },
                onCompleted: (data) {
                  print("data  :$data");
                },
              ),
              builder: (runMutation, result) {
                return ElevatedButton(
                  onPressed: () {
                    runMutation({
                      "input": {
                        'title': titleController.text,
                        'completed': false
                      }
                    });
                    print("result   :$result");
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
