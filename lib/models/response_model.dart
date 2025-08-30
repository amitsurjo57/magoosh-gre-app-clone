class ResponseModel {
  final String message;
  final dynamic data;
  final bool isSuccessful;

  ResponseModel({
    required this.message,
    required this.isSuccessful,
    this.data,
  });
}
