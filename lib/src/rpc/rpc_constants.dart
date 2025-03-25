/// Constants for Solana RPC endpoints and configuration
class SolanaRpcConstants {
  /// Private constructor to prevent instantiation
  const SolanaRpcConstants._();

  /// Mainnet RPC endpoint
  static const String mainnetUrl = 'https://api.mainnet-beta.solana.com';
  
  /// Devnet RPC endpoint
  static const String devnetUrl = 'https://api.devnet.solana.com';
  
  /// Testnet RPC endpoint
  static const String testnetUrl = 'https://api.testnet.solana.com';
  
  /// Default headers for RPC requests
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
}