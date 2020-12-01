import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io_client;

import 'common.dart';
import 'event.dart';

enum RequestBodyEncoding { JSON, FormURLEncoded, PlainText }
enum HttpMethod { GET, PUT, PATCH, POST, DELETE, HEAD }

class Response {
  final http.Response _rawResponse;

  Response(this._rawResponse);

  int get statusCode => _rawResponse.statusCode;

  bool get hasError => (400 <= statusCode) && (statusCode < 600);

  bool get success => !hasError;

  Uri get url => _rawResponse.request.url;

  Map<String, String> get headers => _rawResponse.headers;

  String get contentType => _rawResponse.headers['content-type'];

  throwForStatus() {
    if (!success) {
      throw HTTPException(
          'Invalid HTTP status code $statusCode for url ${url}', this);
    }
  }

  raiseForStatus() {
    throwForStatus();
  }

  List<int> bytes() {
    return _rawResponse.bodyBytes;
  }

  String content() {
    return utf8.decode(bytes(), allowMalformed: true);
  }

  dynamic json() {
    return Common.fromJson(content());
  }
}

class HTTPException implements Exception {
  final String message;
  final Response response;

  HTTPException(this.message, this.response);
}

class Requests {
  const Requests();
  static final Event onError = Event();
  static const int DEFAULT_TIMEOUT_SECONDS = 10;
  static const RequestBodyEncoding DEFAULT_BODY_ENCODING = RequestBodyEncoding.FormURLEncoded;

  static Map _constructRequestHeaders(Map<String, String> customHeaders) {
    Map<String, String> requestHeaders = Map();
    if (customHeaders != null) {
      requestHeaders.addAll(customHeaders);
    }
	 if (Globals.token != null)
	 	requestHeaders['Authorization'] = 'Bearer ${Globals.token}';
    return requestHeaders;
  }

  static Future<Response> _handleHttpResponse(http.Response rawResponse) async {

    var response = Response(rawResponse);

    if (response.hasError) {
      var errorEvent = {'response': response};
      onError.publish(errorEvent);
    }

    return response;
  }

  static Future<Response> head(String url,
      {Map<String, String> headers,
      Map<String, dynamic> queryParameters,
      int port,
      RequestBodyEncoding bodyEncoding = DEFAULT_BODY_ENCODING,
      int timeoutSeconds = DEFAULT_TIMEOUT_SECONDS,
      bool verify = true
		}) {
    return _httpRequest(HttpMethod.HEAD, url,
        bodyEncoding: bodyEncoding,
        queryParameters: queryParameters,
        port: port,
        headers: headers,
        timeoutSeconds: timeoutSeconds,
                verify: verify);
  }

  static Future<Response> get(String url,
      {Map<String, String> headers,
      Map<String, dynamic> queryParameters,
      int port,
      dynamic json,
      dynamic body,
      RequestBodyEncoding bodyEncoding = DEFAULT_BODY_ENCODING,
      int timeoutSeconds = DEFAULT_TIMEOUT_SECONDS,
            bool verify = true}) {
    return _httpRequest(HttpMethod.GET, url,
        bodyEncoding: bodyEncoding,
        queryParameters: queryParameters,
        port: port,
        json: json,
        body: body,
        headers: headers,
        timeoutSeconds: timeoutSeconds,
                verify: verify);
  }

  static Future<Response> patch(String url,
      {Map<String, String> headers,
      int port,
      dynamic json,
      dynamic body,
      Map<String, dynamic> queryParameters,
      RequestBodyEncoding bodyEncoding = DEFAULT_BODY_ENCODING,
      int timeoutSeconds = DEFAULT_TIMEOUT_SECONDS,
            bool verify = true}) {
    return _httpRequest(HttpMethod.PATCH, url,
        bodyEncoding: bodyEncoding,
        port: port,
        json: json,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
        timeoutSeconds: timeoutSeconds,
                verify: verify);
  }

  static Future<Response> delete(String url,
      {Map<String, String> headers,
      dynamic json,
      dynamic body,
      Map<String, dynamic> queryParameters,
      int port,
      RequestBodyEncoding bodyEncoding = DEFAULT_BODY_ENCODING,
      int timeoutSeconds = DEFAULT_TIMEOUT_SECONDS,
            bool verify = true}) {
    return _httpRequest(HttpMethod.DELETE, url,
        bodyEncoding: bodyEncoding,
        port: port,
        json: json,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
        timeoutSeconds: timeoutSeconds,
                verify: verify);
  }

  static Future<Response> post(String url,
      {dynamic json,
      int port,
      dynamic body,
      Map<String, dynamic> queryParameters,
      RequestBodyEncoding bodyEncoding = DEFAULT_BODY_ENCODING,
      Map<String, String> headers,
      int timeoutSeconds = DEFAULT_TIMEOUT_SECONDS,
            bool verify = true}) {
    return _httpRequest(HttpMethod.POST, url,
        bodyEncoding: bodyEncoding,
        json: json,
        port: port,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
        timeoutSeconds: timeoutSeconds,
                verify: verify);
  }

  static Future<Response> put(
    String url, {
    int port,
    dynamic json,
    dynamic body,
    Map<String, dynamic> queryParameters,
    RequestBodyEncoding bodyEncoding = DEFAULT_BODY_ENCODING,
    Map<String, String> headers,
    int timeoutSeconds = DEFAULT_TIMEOUT_SECONDS,
        bool verify = true,
  }) {
    return _httpRequest(
      HttpMethod.PUT,
      url,
      port: port,
      bodyEncoding: bodyEncoding,
      json: json,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      timeoutSeconds: timeoutSeconds,
      verify: verify,
    );
  }

  static Future<Response> _httpRequest(HttpMethod method, String url,
      {
        dynamic json,
        dynamic body,
        RequestBodyEncoding bodyEncoding = DEFAULT_BODY_ENCODING,
        Map<String, dynamic> queryParameters,
        int port,
        Map<String, String> headers,
        int timeoutSeconds = DEFAULT_TIMEOUT_SECONDS,
                bool verify = true
      }) async {
    http.Client client;
    if (!verify) {
      // Ignore SSL errors
      var ioClient = HttpClient();
      ioClient.badCertificateCallback = (_, __, ___) => true;
      client = io_client.IOClient(ioClient);
    } else {
      // The default client validates SSL certificates and fail if invalid
      client = http.Client();
    }

    var uri = Uri.parse(url);

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw ArgumentError(
          "invalid url, must start with 'http://' or 'https://' sheme (e.g. 'http://example.com')");
    }

    headers = await _constructRequestHeaders(headers);
    String requestBody;

    if (body != null && json != null) {
      throw ArgumentError('cannot use both "json" and "body" choose only one.');
    }

    if (queryParameters != null) {
      Map<String, String> stringQueryParameters = Map();
      queryParameters.forEach((key, value) => stringQueryParameters[key] = value?.toString());
      uri = uri.replace(queryParameters: stringQueryParameters);
    }

    if (port != null) {
      uri = uri.replace(port: port);
    }

    if (json != null) {
      body = json;
      bodyEncoding = RequestBodyEncoding.JSON;
    }

    if (body != null) {
      String contentTypeHeader;

      switch (bodyEncoding) {
        case RequestBodyEncoding.JSON:
          requestBody = Common.toJson(body);
          contentTypeHeader = 'application/json';
          break;
        case RequestBodyEncoding.FormURLEncoded:
          requestBody = Common.encodeMap(body);
          contentTypeHeader = 'application/x-www-form-urlencoded';
          break;
        case RequestBodyEncoding.PlainText:
          requestBody = body;
          contentTypeHeader = 'text/plain';
          break;
      }

      if (contentTypeHeader != null &&
          !Common.hasKeyIgnoreCase(headers, 'content-type')) {
        headers['content-type'] = contentTypeHeader;
      }
    }

    Future future;

    switch (method) {
      case HttpMethod.GET:
        future = client.get(uri, headers: headers);
        break;
      case HttpMethod.PUT:
        future = client.put(uri, body: requestBody, headers: headers);
        break;
      case HttpMethod.DELETE:
        final request = http.Request('DELETE', uri);
        request.headers.addAll(headers);

        if (requestBody != null) {
          request.body = requestBody;
        }

        future = client.send(request);
        break;
      case HttpMethod.POST:
        future = client.post(uri, body: requestBody, headers: headers);
        break;
      case HttpMethod.HEAD:
        future = client.head(uri, headers: headers);
        break;
      case HttpMethod.PATCH:
        future = client.patch(uri, body: requestBody, headers: headers);
        break;
    }

    var response = await future.timeout(Duration(seconds: timeoutSeconds));

    if (response is http.StreamedResponse) {
      response = await http.Response.fromStream(response);
    }

    return await _handleHttpResponse(response);
  }
}
