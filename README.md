# jaguar_jwt_auth

JWT authentication interceptor for Jaguar

## Usage

A simple usage example:

```dart
/// File: main.dart
library jaguar.example.silly;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_jwt_auth/jaguar_jwt_auth.dart';

part 'main.g.dart';

@Api(path: '/api')
class ExampleApi extends _$JaguarExampleApi {
  int _pingCount = 0;

  @Route('/ping', methods: const <String>['GET'])
  String ping() => "You pinged me ${++_pingCount} times, silly!";

  @JwtAuth(const JwtInfo('secret here'), const <String>['player', 'admin'])
  @Route('/pong', methods: const <String>['POST'])
  String pong() => "Your silly pongs have no effect on me!";
}

Future<Null> main(List<String> args) async {
  ExampleApi api = new ExampleApi();

  Configuration configuration = new Configuration();
  configuration.addApi(api);

  await serve(configuration);
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
