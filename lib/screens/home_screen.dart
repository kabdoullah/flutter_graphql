import 'package:flutter/material.dart';
import 'package:flutter_graphql_crud/screens/create_todo_screen.dart';
import 'package:flutter_graphql_crud/screens/detail_screen.dart';
import 'package:flutter_graphql_crud/services/queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Query(
            options: QueryOptions(
              document: gql(todoPaginationQuery),
              variables: {
                "options": {
                  "paginate": {"page": _page, "limit": 10}
                }
              },
            ),
            builder: (result, {fetchMore, refetch}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List? todos = result.data?['todos']['data'];
              if (todos == null) {
                return const Text('No todo');
              }
              print("todos   $todos");
              return Expanded(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      leading: Text(todo['id']),
                      title: Text(todo['title']),
                      trailing: Checkbox(
                          onChanged: (value) {}, value: todo['completed']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(id: todo['id']),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _page = _page + 1;
              });
            },
            child: const Text("Load more"),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateTodoScreen(),
                  ));
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          Mutation(
            options: MutationOptions(
              document: gql(deleteTodo),
              onCompleted: (data) {
                print("data     : $data");
              },
            ),
            builder: (runMutation, result) {
              return FloatingActionButton(
                onPressed: () {
                  runMutation({"id": 100});
                },
                child: const Icon(Icons.delete),
              );
            },
          )
        ],
      ),
    );
  }
}
