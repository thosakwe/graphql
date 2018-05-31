import 'package:graphql_parser/graphql_parser.dart';

DocumentContext parseDocument(String str) =>
    new Parser(scan(str)).parseDocument();