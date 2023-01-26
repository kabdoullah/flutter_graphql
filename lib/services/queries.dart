// Query
String getAllTodo = """
query {
  todos{
    data{
      id, 
      title, 
      completed
    }
  }
}
 """;

String getTodoById = """ 
query todo(\$id : ID!) {
  todo(id: \$id){
    id
    title
    completed
  }
}

""";

String todoPaginationQuery = """
query Todos(\$options: PageQueryOptions) {
  todos(options: \$options) {
    data {
      id
      title
      completed
    }
    links {
      next{
        page
      }
    }
  }
}
 """;

//Mutation
String createTodo = """ 
mutation CreateTodo(\$input: CreateTodoInput!){
  createTodo(input: \$input) {
    id
    title
    completed
  }
}
""";
String updateTodo = """ 
mutation UpdateTodo(\$id: ID!, \$input: UpdateTodoInput!) {
  updateTodo(id: \$id, input: \$input) {
    id
    title
    completed
  }
}
""";

String deleteTodo = """
mutation DeleteTodo(\$id: ID!){
  deleteTodo(id: \$id)
}
""";
