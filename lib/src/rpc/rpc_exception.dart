class SolanaRpcException implements Exception {
  final int code;
  final String message;
  final dynamic data;
  
  SolanaRpcException({
    required this.code,
    required this.message,
    this.data,
  });
  
  @override
  String toString() => 'SolanaRpcException: [$code] $message${data != null ? " - $data" : ""}';
}