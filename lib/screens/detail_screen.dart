import 'package:flutter/material.dart';
import 'package:flutter_graphql_crud/screens/update_todo_screen.dart';
import 'package:flutter_graphql_crud/services/queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Detail"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Query(
          options: QueryOptions(
            document: gql(getTodoById),
            variables: {
              'id': id,
            },
            pollInterval: const Duration(seconds: 10),
          ),
          builder: (result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            var todo = result.data!['todo'];
            if (todo == null) {
              return const Text("No Todo");
            }

            return ListTile(
              leading: Text(todo['id']),
              title: Text(todo['title']),
              trailing:
                  Checkbox(onChanged: (value) {}, value: todo['completed']),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateTodoScreen(),
              ));
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
