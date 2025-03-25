// import '../rpc/rpc_client.dart';
// import '../address/address_validator.dart';

// class SolanaTokenBalanceChecker {
//   final SolanaRpcClient _rpcClient;
  
//   // Token Program ID on Solana
//   static const String TOKEN_PROGRAM_ID = 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA';
  
//   SolanaTokenBalanceChecker({SolanaRpcClient? rpcClient})
//       : _rpcClient = rpcClient ?? SolanaRpcClient();
  
//   /// Get SOL balance for an address
//   Future<double> getSolBalance(String address) async {
//     if (!SolanaAddressValidator.isValidFormat(address)) {
//       throw FormatException('Invalid Solana address format');
//     }
    
//     try {
//       final response = await _rpcClient.call('getBalance', [address]);
//       final int lamports = response['result']['value'];
//       return lamports / 1000000000; // Convert lamports to SOL
//     } catch (e) {
//       rethrow;
//     }
//   }
  
//   /// Get token accounts by owner
//   Future<List<TokenAccount>> getTokenAccounts(String ownerAddress) async {
//     if (!SolanaAddressValidator.isValidFormat(ownerAddress)) {
//       throw FormatException('Invalid Solana address format');
//     }
    
//     try {
//       final response = await _rpcClient.call(
//         'getTokenAccountsByOwner',
//         [
//           ownerAddress,
//           {'programId': TOKEN_PROGRAM_ID},
//           {'encoding': 'jsonParsed'}
//         ]
//       );
      
//       final List<dynamic> accounts = response['result']['value'];
//       return accounts.map((account) {
//         final info = account['account']['data']['parsed']['info'];
        
//         return TokenAccount(
//           address: account['pubkey'],
//           mint: info['mint'],
//           owner: info['owner'],
//           amount: _parseTokenAmount(info['tokenAmount']),
//           decimals: info['tokenAmount']['decimals'],
//           uiAmount: info['tokenAmount']['uiAmount'],
//         );
//       }).toList();
//     } catch (e) {
//       return [];
//     }
//   }
  
//   /// Get specific token balance for an owner
//   Future<double> getTokenBalance(String ownerAddress, String mintAddress) async {
//     if (!SolanaAddressValidator.isValidFormat(ownerAddress) || 
//         !SolanaAddressValidator.isValidFormat(mintAddress)) {
//       throw FormatException('Invalid Solana address format');
//     }
    
//     try {
//       final accounts = await getTokenAccounts(ownerAddress);
//       final tokenAccount = accounts.firstWhere(
//         (account) => account.mint == mintAddress,
//         orElse: () => TokenAccount(
//           address: '', 
//           mint: mintAddress, 
//           owner: ownerAddress, 
//           amount: BigInt.zero, 
//           decimals: 0, 
//           uiAmount: 0
//         ),
//       );
      
//       return tokenAccount.uiAmount;
//     } catch (e) {
//       return 0.0;
//     }
//   }
  
//   /// Parse token amount from RPC response
//   BigInt _parseTokenAmount(Map<String, dynamic> tokenAmount) {
//     final String amount = tokenAmount['amount'];
//     return BigInt.parse(amount);
//   }
// }

// class TokenAccount {
//   final String address;
//   final String mint;
//   final String owner;
//   final BigInt amount;
//   final int decimals;
//   final double uiAmount;
  
//   TokenAccount({
//     required this.address,
//     required this.mint,
//     required this.owner,
//     required this.amount,
//     required this.decimals,
//     required this.uiAmount,
//   });
  
//   Map<String, dynamic> toJson() {
//     return {
//       'address': address,
//       'mint': mint,
//       'owner': owner,
//       'amount': amount.toString(),
//       'decimals': decimals,
//       'uiAmount': uiAmount,
//     };
//   }
// }