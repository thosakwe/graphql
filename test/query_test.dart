import 'package:graphql/src/query_executor.dart';
import 'package:test/test.dart';
import 'common.dart';

main() {
  Map<String, dynamic> lukeSkywalker, obiWan, hero, starWars;

  setUp(() {
    lukeSkywalker = {'id': '1000', 'name': 'Luke Skywalker', 'height': 1.72};

    obiWan = {'id': '1001', 'name': 'Obi-wan Kenobi', 'height': 1.40};

    hero = {
      'name': 'Tobe O',
      'friends': [lukeSkywalker]
    };

    starWars = {
      'hero': hero,
      'human': [lukeSkywalker, obiWan]
    };
  });

  test('basic query', () {
    var doc = parseDocument('''
{
  hero {
    name
    friends {
      name
    }
  }
}
    ''');
    var result = const GraphQLQueryExecutor().visitDocument(doc, starWars);
    print('Result: $result');

    expect(result, {
      'data': {
        'hero': {
          'name': 'Tobe O',
          'friends': [
            {'name': 'Luke Skywalker'}
          ]
        }
      }
    });
  });

  test('unknown field in query', () {
    var doc = parseDocument('''
{
  hero {
    name
    friends {
      last_name
    }
  }
}
    ''');
    var result = const GraphQLQueryExecutor().visitDocument(doc, starWars);
    print('Result: $result');

    expect(result, {
      'data': {
        'hero': new Map.from(hero)
          ..['friends'] =
              new List.from(hero['friends']..[0] = {'last_name': null})
      }
    });
  });

  test('arguments in query', () {
    var doc = parseDocument('''
{
  human(id: "1000") {
    name
    height
  }
}
    ''');
    var result = const GraphQLQueryExecutor().visitDocument(doc, starWars);
    print('Result: $result');
    expect(result, {
      'data': {
        'human': {'name': 'Luke Skywalker', 'height': 1.72}
      }
    });
  });

  test('deep args', () {
    var doc = parseDocument('''
{
  hero {
    name
    friends(name: "Luke Skywalker") {
      name,
      height
    }
  }
}
    ''');
    var result = const GraphQLQueryExecutor().visitDocument(doc, starWars);
    print('Result: $result');
    expect(result, {
      'data': {
        'hero': {
          'name': 'Tobe O',
          'friends': [
            {'name': 'Luke Skywalker', 'height': 1.72}
          ]
        }
      }
    });
  });
}
