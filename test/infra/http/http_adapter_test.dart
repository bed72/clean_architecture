import 'package:http/http.dart';

import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bed/data/http/http.dart';
import 'package:bed/infra/http/http.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late String url;
  late HttpAdapter sut;
  late ClientSpy client;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('shared', () {
    test(' 🔧 Should throw Server Error if invalid method is provided',
        () async {
      final future = sut.request(
        url: url,
        method: 'invalid_method',
        body: {'any_key': 'any_value'},
      );

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('post', () {
    When<Future<Response>> _mockRequest() => when(() => client.post(
          Uri.parse(url),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ));

    void mockResponse(
      int statusCode, {
      String body = '{"any_key":"any_value"}',
    }) {
      _mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      _mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test(' 🔧 Should call post with correct values', () async {
      await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
      );

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json'
            },
            body: '{"any_key":"any_value"}',
          ));
    });

    test(' 🔧 Should call post without body', () async {
      await sut.request(url: url, method: 'post');

      verify(() => client.post(Uri.parse(url), headers: any(named: 'headers')));
    });

    test(' 🔧 Should return data if post return 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test(' 🔧 Should return null if post return 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test(' 🔧 Should return null if post return 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test(' 🔧 Should return null if post return 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test(
        ' 🔧 Should return Bad Request Error if post return 400 with data (optional)',
        () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test(' 🔧 Should return Bad Request Error if post return 400', () async {
      mockResponse(400);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test(' 🔧 Should return Unathorized Error if post return 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test(' 🔧 Should return Forbidden Error if post return 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test(' 🔧 Should return Not Found Error if post return 404', () async {
      mockResponse(404);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test(' 🔧 Should return Server Error if post return 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });

    test(' 🔧 Should return Server Error if post throws', () async {
      mockError();

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
