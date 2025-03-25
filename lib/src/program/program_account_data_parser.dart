// import '../rpc/rpc_client.dart';
// import '../address/address_validator.dart';

// class SolanaProgramAccountParser {
//   final SolanaRpcClient _rpcClient;
  
//   SolanaProgramAccountParser({SolanaRpcClient? rpcClient})
//       : _rpcClient = rpcClient ?? SolanaRpcClient();
  
//   /// Get accounts owned by a program
//   Future<List<ProgramAccount>> getProgramAccounts(
//     String programId, {
//     Map<String, dynamic>? filters,
//     String encoding = 'base64',
//     bool withContext = false,
//   }) async {
//     if (!SolanaAddressValidator.isValidFormat(programId)) {
//       throw FormatException('Invalid program ID format');
//     }
    
//     try {
//       final params = [
//         programId,
//         {'encoding': encoding}
//       ];
      
//       if (filters != null) {
//         (params[1] as Map<String, dynamic>)['filters'] = filters;
//       }
      
//       if (withContext) {
//         (params[1] as Map<String, dynamic>)['withContext'] = true;
//       }
      
//       final response = await _rpcClient.call('getProgramAccounts', params);
      
//       final List<dynamic> accounts = response['result'];
//       return accounts.map((account) {
//         return ProgramAccount(
//           pubkey: account['pubkey'],
//           account: AccountData.fromJson(account['account']),
//           data: account['account']['data'][0] as String,
//         );
//       }).toList();
//     } catch (e) {
//       return [];
//     }
//   }
  
//   /// Parse account data based on the program
//   Future<Map<String, dynamic>?> parseAccountData(
//     String address,
//     String programId,
//   ) async {
//     if (!SolanaAddressValidator.isValidFormat(address) ||
//         !SolanaAddressValidator.isValidFormat(programId)) {
//       throw FormatException('Invalid address format');
//     }
    
//     try {
//       final response = await _rpcClient.call(
//         'getAccountInfo',
//         [address, {'encoding': 'jsonParsed'}]
//       );
      
//       final result = response['result']['value'];
//       if (result == null) return null;
      
//       // For token program accounts, Solana RPC returns parsed data
//       if (result['data']['program'] == 'spl-token') {
//         return result['data']['parsed']['info'];
//       }
      
//       // For other programs, we'd need custom parsers
//       // This is a simplified approach
//       return {
//         'owner': result['owner'],
//         'lamports': result['lamports'],
//         'rentEpoch': result['rentEpoch'],
//         'executable': result['executable'],
//         'rawData': result['data'][0],
//       };
//     } catch (e) {
//       return null;
//     }
//   }
  
//   /// Helper for parsing instruction data, useful for transaction inspection
//   static Map<String, dynamic> parseInstructionData(
//     String programId,
//     String data, 
//   ) {
//     // Known program-specific parsers would go here
//     // This is a simplified implementation
    
//     // For token program
//     if (programId == 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA') {
//       // The first byte often indicates the instruction type for many programs
//       // This is a simplification for demonstration
//       if (data.startsWith('3d')) {
//         return {'instruction': 'transfer'};
//       } else if (data.startsWith('7e')) {
//         return {'instruction': 'mintTo'};
//       } else if (data.startsWith('1')) {
//         return {'instruction': 'initializeAccount'};
//       }
//     }
    
//     // For system program
//     if (programId == '11111111111111111111111111111111') {
//       if (data.startsWith('2')) {
//         return {'instruction': 'transfer'};
//       } else if (data.startsWith('0')) {
//         return {'instruction': 'createAccount'};
//       }
//     }
    
//     // Default return with raw data
//     return {'instruction': 'unknown', 'rawData': data};
//   }
// }

// class ProgramAccount {
//   final String pubkey;
//   final AccountData account;
//   final String data;
  
//   ProgramAccount({
//     required this.pubkey,
//     required this.account,
//     required this.data,
//   });
  
//   Map<String, dynamic> toJson() {
//     return {
//       'pubkey': pubkey,
//       'account': account.toJson(),
//       'data': data,
//     };
//   }
// }

// class AccountData {
//   final int lamports;
//   final String owner;
//   final bool executable;
//   final int rentEpoch;
  
//   AccountData({
//     required this.lamports,
//     required this.owner,
//     required this.executable,
//     required this.rentEpoch,
//   });
  
//   factory AccountData.fromJson(Map<String, dynamic> json) {
//     return AccountData(
//       lamports: json['lamports'] ?? 0,
//       owner: json['owner'] ?? '',
//       executable: json['executable'] ?? false,
//       rentEpoch: json['rentEpoch'] ?? 0,
//     );
//   }
  
//   Map<String, dynamic> toJson() {
//     return {
//       'lamports': lamports,
//       'owner': owner,
//       'executable': executable,
//       'rentEpoch': rentEpoch,
//     };
//   }
// }