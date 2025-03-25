import 'dart:convert';
import 'package:http/http.dart' as http;

import 'rpc_constants.dart';
import 'rpc_exception.dart';

class SolanaRpcClient {
  final String _endpoint;
  final Map<String, String> _headers;
  final Duration _timeout;

 String get endpoint => _endpoint;

  SolanaRpcClient({
    String endpoint = SolanaRpcConstants.mainnetUrl,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
  }) : 
    _endpoint = endpoint,
    _headers = {...SolanaRpcConstants.defaultHeaders, ...?headers},
    _timeout = timeout;

  Future<Map<String, dynamic>> call(String method, List<dynamic> params) async {
    final requestBody = json.encode({
      'jsonrpc': '2.0',
      'id': DateTime.now().millisecondsSinceEpoch,
      'method': method,
      'params': params,
    });

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: _headers,
        body: requestBody,
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        
        if (responseJson.containsKey('error')) {
          final error = responseJson['error'];
          throw SolanaRpcException(
            code: error['code'] ?? -1,
            message: error['message'] ?? 'Unknown RPC error',
            data: error['data'],
          );
        }
        
        return responseJson;
      } else {
        throw SolanaRpcException(
          code: response.statusCode,
          message: 'HTTP error ${response.statusCode}',
          data: response.body,
        );
      }
    } catch (e) {
      if (e is SolanaRpcException) rethrow;
      throw SolanaRpcException(
        code: -1000,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }
  
  // Helper method to get account info
  Future<Map<String, dynamic>> getAccountInfo(String address, {String encoding = 'base64'}) async {
    return call('getAccountInfo', [
      address, 
      {'encoding': encoding}
    ]);
  }
  
  // Helper method to get balance
  Future<int> getBalance(String address) async {
    final response = await call('getBalance', [address]);
    return response['result']['value'] as int;
  }
  
  // Helper method to get recent blockhash
  Future<String> getRecentBlockhash() async {
    final response = await call('getRecentBlockhash', []);
    return response['result']['value']['blockhash'] as String;
  }
  
  // Helper method to get protocol version
  Future<String> getVersion() async {
    final response = await call('getVersion', []);
    return response['result']['solana-core'] as String;
  }
  
  // Helper method to get minimum balance for rent exemption
  Future<int> getMinimumBalanceForRentExemption(int size) async {
    final response = await call('getMinimumBalanceForRentExemption', [size]);
    return response['result'] as int;
  }
}

