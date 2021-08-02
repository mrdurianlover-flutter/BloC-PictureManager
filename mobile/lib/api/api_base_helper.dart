import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:picts_manager/utils/generate_header.dart';
import 'app_exception.dart';

class ApiBaseHelper {
  String baseUrl;

  ApiBaseHelper(
      {this.baseUrl = kDebugMode
          ? "https://pic-dev.courthias.space/api/v1"
          : "https://pic.courthias.space/api/v1"});

  Future<dynamic> get(String urlString, {Map<String, String>? headers}) async {
    print('GET: url $baseUrl$urlString');
    var responseJson;
    try {
      final url = Uri.parse(baseUrl + urlString);
      final response = await http.get(url, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postFile(
      String urlString, String file, Map<String, String> fields,
      {Map<String, String>? headers}) async {
    print('POST: $file $fields');
    var response;
    try {
      final url = Uri.parse(baseUrl + urlString);
      var request = http.MultipartRequest('POST', url)
        ..fields.addAll(fields)
        ..headers.addAll(await getBearedHeaderFormData())
        ..files.add(await http.MultipartFile.fromPath("photo", file,
            contentType: new MediaType('image', 'jpeg')));
      var streamedResponse = await request.send();
      response =
          _returnResponse(await http.Response.fromStream(streamedResponse));
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<dynamic> post(String urlString,
      {dynamic body, Map<String, String>? headers}) async {
    print('POST: url $baseUrl$urlString\nBody: $body');
    var responseJson;
    try {
      final url = Uri.parse(baseUrl + urlString);
      final response = await http.post(url, body: body, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> put(String urlString, dynamic body,
      {Map<String, String>? headers}) async {
    print('Api Put, url $baseUrl$urlString');
    var responseJson;
    try {
      final url = Uri.parse(baseUrl + urlString);
      final response = await http.put(url, body: body, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api put.');
    // print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(String urlString,
      {Map<String, String>? headers}) async {
    print('Api delete, url $urlString');
    var apiResponse;
    try {
      final url = Uri.parse(baseUrl + urlString);
      final response = await http.delete(url, headers: headers);
      apiResponse = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api delete.');
    return apiResponse;
  }
}

dynamic _returnResponse(http.Response response) {
  var apiResponse = json.decode(response.body.toString());
  // print(apiResponse);
  switch (response.statusCode) {
    case 200:
      return apiResponse;
    default:
      throw APIException(apiResponse["message"]);
  }
}
