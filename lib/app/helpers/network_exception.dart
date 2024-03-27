import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String? prefix;
  final Response? response;

  NetworkException({
    this.prefix,
    this.response,
  });

  @override
  String toString() {
    var result = '';
    if (response?.statusCode == 400 ||
        response?.data == 401 ||
        response?.statusCode == 409) {
      var message = jsonDecode(jsonEncode(response?.data))?['message'];
      if (message != null) {
        result += message ?? '';
      } else {
        result += prefix ?? '';
      }
    } else {
      result += prefix ?? '';
    }
    return result;
  }

  static NetworkException handleResponse(Response response) {
    var statusCode = response.statusCode!;
    var responseCode = statusCode;
    return FetchDataException(
      message: 'Received invalid status code: $responseCode',
      response: response,
    );
  }

  static NetworkException getErrorException(error) {
    if (error is Exception) {
      print('NetworkException: 1');
      try {
        NetworkException networkExceptions;
        if (error is DioException) {
          networkExceptions = NetworkException.handleResponse(error.response!);
        } else if (error is SocketException) {
          print('NetworkException: 10');
          networkExceptions = FetchDataException();
        } else {
          print('NetworkException: 11');
          networkExceptions = FetchDataException();
        }
        print('NetworkException: 12');
        return networkExceptions;
      } on FormatException catch (_) {
        return FetchDataException();
      } catch (_) {
        return FetchDataException();
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return FetchDataException();
      } else {
        return FetchDataException();
      }
    }
  }
}

class ConnectionTimeOutException extends NetworkException {
  ConnectionTimeOutException() : super(prefix: 'Connection Timeout');
}

class ReceiveTimeOutException extends NetworkException {
  ReceiveTimeOutException() : super(prefix: 'Receive Timeout');
}

class SendTimeOutException extends NetworkException {
  SendTimeOutException() : super(prefix: 'Send Timeout');
}

class InternalServerErrorException extends NetworkException {
  InternalServerErrorException() : super(prefix: 'Internal Server Error');
}

class RequestEntityTooLargeException extends NetworkException {
  RequestEntityTooLargeException({String? message, Response? response})
      : super(
          prefix: 'Request Entity Too Large',
          response: response,
        );
}

class FetchDataException extends NetworkException {
  FetchDataException({String? message, Response? response})
      : super(
          prefix: 'Error During Communication',
          response: response,
        );
}

class NotFoundException extends NetworkException {
  NotFoundException({String? message, Response? response})
      : super(
          prefix: 'Not Found',
          response: response,
        );
}

class BadRequestException extends NetworkException {
  BadRequestException({String? message, Response? response})
      : super(
          prefix: 'Invalid Request',
          response: response,
        );
}

class UnauthorisedException extends NetworkException {
  UnauthorisedException({String? message, Response? response})
      : super(
          prefix: 'Unauthorised',
          response: response,
        );
}

class InvalidInputException extends NetworkException {
  InvalidInputException({String? message, Response? response})
      : super(
          prefix: 'Invalid Input',
          response: response,
        );
}

class RequestCancelled extends NetworkException {
  RequestCancelled({String? message, Response? response})
      : super(
          prefix: 'Request Cancelled',
          response: response,
        );
}
