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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos"),
        centerTitle: true,
      ),
      body: Query(
        options: QueryOptions(
          document: gql(todoPaginationQuery),
          variables: const {
            "options": {
              "paginate": {"page": 1, "limit": 10}
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
          int? nextPage = result.data?['todos']?['links']?['next']?['page'];
          print("NextPage    : $nextPage");
          final opts = FetchMoreOptions(
              variables: {
                "options": {
                  "paginate": {"page": nextPage, "limit": 10}
                }
              },
              updateQuery: (previousResultData, fetchMoreResultData) {
                final List<dynamic> repos = [
                  ...previousResultData?['todos']['data'] as List<dynamic>,
                  ...fetchMoreResultData?['todos']['data'] as List<dynamic>
                ];

                fetchMoreResultData?['todos']['data'] = repos;

                return fetchMoreResultData;
              });

          if (todos == null) {
            return const Text('No todo');
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Column(
                children: [
                  ListTile(
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
                  ),
                  if (todos.length - 1 == index)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        nextPage == null
                            ? Container()
                            : ElevatedButton(
                                onPressed: () {
                                  fetchMore!(opts);
                                },
                                child: const Text("Load more"),
                              ),
                        const SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            refetch!();
                          },
                          child: const Text("Refresh"),
                        ),
                      ],
                    )
                ],
              );
            },
          );
        },
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
