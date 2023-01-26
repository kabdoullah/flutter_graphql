import 'package:flutter/material.dart';
import 'package:flutter_graphql_crud/constants.dart';
import 'package:flutter_graphql_crud/screens/home_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(link: httpLink, cache: GraphQLCache(store: HiveStore())),
  );

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
