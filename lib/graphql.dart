import 'dart:async';
import 'package:graphql_parser/graphql_parser.dart';
import 'package:graphql_schema/graphql_schema.dart';
import 'src/query_executor.dart';

/// Fetches data to filter for GraphQL queries.
typedef FutureOr DataSource();

/// Queries a [DataSource], and returns custom GraphQL-compatible responses.
class GraphQL {
  /// Fetches data to filter for GraphQL queries.
  final DataSource dataSource;

  /// An optional [GraphQLSchema] to validate and serialize data.
  final GraphQLSchema schema;

  GraphQL(this.dataSource, {this.schema});

  Future<Map> query(DocumentContext document) async {
    var fetched = await new Future.sync(dataSource);
    var processed =
        const GraphQLQueryExecutor().visitDocument(document, fetched);

    if (schema != null) {
      return {'data': schema.query.serialize(processed['data'])};
    } else
      return processed;
  }
}
