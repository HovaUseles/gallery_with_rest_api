import 'dart:io';

class MissingUriException extends HttpException {
  MissingUriException(String message) : super(message);
}