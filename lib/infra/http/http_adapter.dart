import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map<String, dynamic>?> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    var response = Response('', 500);

    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final json = body != null ? jsonEncode(body) : null;

    try {
      if (method == 'post') {
        response = await client.post(
          Uri.parse(url),
          headers: headers,
          body: json,
        );
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handlerResponse(response);
  }

  Map<String, dynamic>? _handlerResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty
          ? null
          : jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }
}
