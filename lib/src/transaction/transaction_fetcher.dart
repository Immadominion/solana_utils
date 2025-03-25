import '../rpc/rpc_client.dart';
import '../rpc/rpc_exception.dart';
import '../signature/signature_validator.dart';
import 'solana_transaction_model.dart';
import 'transaction_status.dart';

class SolanaTransactionFetcher {
  final SolanaRpcClient _rpcClient;
  
  SolanaTransactionFetcher({SolanaRpcClient? rpcClient})
      : _rpcClient = rpcClient ?? SolanaRpcClient();
  
  /// Fetch detailed transaction information
  Future<SolanaTransaction?> fetchTransaction(String signature) async {
    if (!SolanaSignatureValidator.isValidFormat(signature)) {
      throw FormatException('Invalid transaction signature format');
    }

    try {
      final response = await _rpcClient.call('getTransaction', [
        signature,
        {'encoding': 'json', 'maxSupportedTransactionVersion': 0}
      ]);

      final result = response['result'];
      if (result == null) return null;
      
      return SolanaTransaction.fromJson(result);
    } catch (e) {
      if (e is SolanaRpcException) {
        if (e.code == -32602) {
          // Invalid parameter
          return null;
        }
      }
      rethrow;
    }
  }
  
  /// Get status confirmations for transaction
  Future<TransactionStatus> getTransactionStatus(String signature) async {
    if (!SolanaSignatureValidator.isValidFormat(signature)) {
      throw FormatException('Invalid transaction signature format');
    }

    try {
      final response = await _rpcClient.call('getSignatureStatuses', [
        [signature],
        {'searchTransactionHistory': true}
      ]);

      final statuses = response['result']['value'];
      if (statuses == null || statuses.isEmpty || statuses[0] == null) {
        return TransactionStatus.notFound;
      }

      final status = statuses[0];
      if (status['err'] != null) {
        return TransactionStatus.failed;
      }

      final confirmations = status['confirmations'];
      if (confirmations == null) {
        return TransactionStatus.finalized;
      } else if (confirmations < 32) {
        return TransactionStatus.confirmed;
      } else {
        return TransactionStatus.finalized;
      }
    } catch (e) {
      return TransactionStatus.unknown;
    }
  }
  
  /// Get multiple transactions at once
  Future<List<SolanaTransaction?>> fetchMultipleTransactions(List<String> signatures) async {
    final validSignatures = signatures
        .where((sig) => SolanaSignatureValidator.isValidFormat(sig))
        .toList();
    
    if (validSignatures.isEmpty) return [];
    
    final futures = validSignatures.map(
      (signature) => fetchTransaction(signature).catchError((_) => null)
    );
    
    return Future.wait(futures);
  }
}



