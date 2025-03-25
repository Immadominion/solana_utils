library;

export 'src/address/address_validator.dart';
export 'src/signature/signature_validator.dart';
export 'src/rpc/rpc_client.dart';
export 'src/transaction/transaction_fetcher.dart';

import 'src/address/address_validator.dart';
import 'src/rpc/rpc_constants.dart';
import 'src/signature/signature_validator.dart';
import 'src/rpc/rpc_client.dart';
import 'src/transaction/solana_transaction_model.dart';
import 'src/transaction/transaction_fetcher.dart';
import 'src/transaction/transaction_status.dart';

/// Utility class to provide common Solana-related functions
/// such as address and signature validation, formatting, and
/// transaction fetching.

class SolanaUtils {
  /// Check if a given string is a valid Solana address
  static bool isValidAddress(String address) => 
      SolanaAddressValidator.isValidFormat(address);
      
  /// Check if a given string is a valid Solana signature
  static bool isValidSignature(String signature) => 
      SolanaSignatureValidator.isValidFormat(signature);
  
  /// Format a Solana address for display
  static String formatAddress(String address) => 
      SolanaAddressValidator.formatForDisplay(address);
      
  /// Format a Solana signature for display
  static String formatSignature(String signature) => 
      SolanaSignatureValidator.formatForDisplay(signature);
  
  /// Factory method to create an RPC client
  static SolanaRpcClient createRpcClient({
    bool useMainnet = true,
    bool useDevnet = false,
    bool useTestnet = false,
    String? customEndpoint,
  }) {
    String endpoint = SolanaRpcConstants.mainnetUrl;
    
    if (customEndpoint != null) {
      endpoint = customEndpoint;
    } else if (useDevnet) {
      endpoint = SolanaRpcConstants.devnetUrl;
    } else if (useTestnet) {
      endpoint = SolanaRpcConstants.testnetUrl;
    }
    
    return SolanaRpcClient(endpoint: endpoint);
  }
  
/// Fetch detailed transaction information for a given signature
  static Future<SolanaTransaction?> getTransactionDetails(
    String signature, {
    bool useMainnet = true,
    bool useDevnet = false,
    bool useTestnet = false,
    String? customEndpoint,
  }) async {
    final rpcClient = createRpcClient(
      useMainnet: useMainnet,
      useDevnet: useDevnet,
      useTestnet: useTestnet,
      customEndpoint: customEndpoint,
    );
    
    final fetcher = SolanaTransactionFetcher(rpcClient: rpcClient);
    return fetcher.fetchTransaction(signature);
  }
  
  // Convenience method to check transaction status
  static Future<TransactionStatus> getTransactionStatus(
    String signature, {
    bool useMainnet = true,
    bool useDevnet = false,
    bool useTestnet = false,
    String? customEndpoint,
  }) async {
    final rpcClient = createRpcClient(
      useMainnet: useMainnet,
      useDevnet: useDevnet,
      useTestnet: useTestnet,
      customEndpoint: customEndpoint,
    );
    
    final fetcher = SolanaTransactionFetcher(rpcClient: rpcClient);
    return fetcher.getTransactionStatus(signature);
  }
}