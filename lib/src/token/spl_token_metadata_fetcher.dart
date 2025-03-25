// import '../rpc/rpc_client.dart';
// import '../address/address_validator.dart';

// class SolanaTokenMetadataFetcher {
//   final SolanaRpcClient _rpcClient;
  
//   // Metaplex Token Metadata Program ID
//   static const String METADATA_PROGRAM_ID = 'metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s';
  
//   SolanaTokenMetadataFetcher({SolanaRpcClient? rpcClient})
//       : _rpcClient = rpcClient ?? SolanaRpcClient();
  
//   /// Find metadata PDA for a mint address
//   Future<String> findMetadataAddress(String mintAddress) async {
//     if (!SolanaAddressValidator.isValidFormat(mintAddress)) {
//       throw FormatException('Invalid mint address format');
//     }
    
//     // This is a simplified version as the proper PDA derivation would require 
//     // ed25519 crypto which we're avoiding for dependencies
//     // In a real implementation, you'd use ed25519 to compute this properly
//     final prefix = 'metadata';
//     final seeds = [
//       prefix,
//       METADATA_PROGRAM_ID,
//       mintAddress,
//     ];
    
//     // This is a mock implementation that follows the pattern but isn't cryptographically correct
//     final String mockPda = '$prefix-$mintAddress'.substring(0, 44);
//     return mockPda;
//   }
  
//   /// Get token metadata for a mint
//   Future<TokenMetadata?> getTokenMetadata(String mintAddress) async {
//     if (!SolanaAddressValidator.isValidFormat(mintAddress)) {
//       throw FormatException('Invalid mint address format');
//     }
    
//     try {
//       final metadataAddress = await findMetadataAddress(mintAddress);
      
//       final response = await _rpcClient.call(
//         'getAccountInfo',
//         [metadataAddress, {'encoding': 'base64'}]
//       );
      
//       final result = response['result']['value'];
//       if (result == null) return null;
      
//       // In a real implementation, you'd decode the binary data properly
//       // For now, we'll attempt to parse JSON data if available in the response
//       try {
//         final Map<String, dynamic> parsedData = result['data'][0];
//         return TokenMetadata.fromJson(parsedData, mintAddress);
//       } catch (e) {
//         // Fallback with minimal info if parsing fails
//         return TokenMetadata(
//           mint: mintAddress,
//           name: 'Unknown Token',
//           symbol: 'UNKNOWN',
//           uri: '',
//           decimals: 0,
//         );
//       }
//     } catch (e) {
//       return null;
//     }
//   }
  
//   /// Alternative method: Get metadata from a token registry (for known tokens)
//   Future<TokenMetadata?> getTokenMetadataFromRegistry(String mintAddress) async {
//     if (!SolanaAddressValidator.isValidFormat(mintAddress)) {
//       throw FormatException('Invalid mint address format');
//     }
    
//     // Common tokens could be stored in a local registry
//     final Map<String, Map<String, dynamic>> tokenRegistry = {
//       'So11111111111111111111111111111111111111112': {
//         'name': 'Wrapped SOL',
//         'symbol': 'SOL',
//         'decimals': 9,
//         'logoURI': 'https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/So11111111111111111111111111111111111111112/logo.png',
//       },
//       'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v': {
//         'name': 'USD Coin',
//         'symbol': 'USDC',
//         'decimals': 6,
//         'logoURI': 'https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v/logo.png',
//       },
//       // Add more well-known tokens as needed
//     };
    
//     if (tokenRegistry.containsKey(mintAddress)) {
//       final data = tokenRegistry[mintAddress]!;
//       return TokenMetadata(
//         mint: mintAddress,
//         name: data['name'],
//         symbol: data['symbol'],
//         uri: data['logoURI'] ?? '',
//         decimals: data['decimals'],
//       );
//     }
    
//     // If not in registry, try to fetch on-chain
//     return getTokenMetadata(mintAddress);
//   }
// }

// class TokenMetadata {
//   final String mint;
//   final String name;
//   final String symbol;
//   final String uri;
//   final int decimals;
//   final Map<String, dynamic>? additionalMetadata;
  
//   TokenMetadata({
//     required this.mint,
//     required this.name,
//     required this.symbol,
//     required this.uri,
//     required this.decimals,
//     this.additionalMetadata,
//   });
  
//   factory TokenMetadata.fromJson(Map<String, dynamic> json, String mintAddress) {
//     return TokenMetadata(
//       mint: mintAddress,
//       name: json['name'] ?? 'Unknown',
//       symbol: json['symbol'] ?? 'UNKNOWN',
//       uri: json['uri'] ?? '',
//       decimals: json['decimals'] ?? 0,
//       additionalMetadata: json,
//     );
//   }
  
//   Map<String, dynamic> toJson() {
//     return {
//       'mint': mint,
//       'name': name,
//       'symbol': symbol,
//       'uri': uri,
//       'decimals': decimals,
//       'additionalMetadata': additionalMetadata,
//     };
//   }
// }