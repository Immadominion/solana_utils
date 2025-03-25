// import '../rpc/rpc_client.dart';

// class SolanaGasFeeEstimator {
//   final SolanaRpcClient _rpcClient;
  
//   SolanaGasFeeEstimator({SolanaRpcClient? rpcClient})
//       : _rpcClient = rpcClient ?? SolanaRpcClient();
  
//   /// Get the recent prioritization fees per Solana block slots
//   Future<List<PrioritizationFee>> getRecentPrioritizationFees() async {
//     try {
//       final response = await _rpcClient.call('getRecentPrioritizationFees', []);
      
//       final List<dynamic> feesData = response['result'];
//       return feesData.map((data) {
//         return PrioritizationFee(
//           slot: data['slot'],
//           prioritizationFee: data['prioritizationFee'],
//         );
//       }).toList();
//     } catch (e) {
//       return [];
//     }
//   }
  
//   /// Estimate fee for a particular transaction size
//   Future<FeeEstimate> estimateFee({
//     int numSignatures = 1,
//     int numAccounts = 3,
//     int dataSize = 0,
//     List<String>? accountKeys,
//   }) async {
//     try {
//       // First get minimum lamports per signature
//       final recentBlockhashResponse = await _rpcClient.call('getFees', []);
//       final int lamportsPerSignature = recentBlockhashResponse['result']['value']['feeCalculator']['lamportsPerSignature'];
      
//       // Base transaction fee is based on signature count
//       int baseFee = lamportsPerSignature * numSignatures;
      
//       // If we have prioritization fees available, use them
//       final recentFees = await getRecentPrioritizationFees();
//       int prioritizationFee = 0;
      
//       if (recentFees.isNotEmpty) {
//         // Calculate median priority fee from recent blocks
//         final List<int> feeValues = recentFees.map((f) => f.prioritizationFee).toList();
//         feeValues.sort();
        
//         // Use the median value as an estimate
//         int medianIndex = feeValues.length ~/ 2;
//         prioritizationFee = feeValues[medianIndex] * dataSize;
//       }
      
//       // Total fee estimate
//       final totalFee = baseFee + prioritizationFee;
      
//       return FeeEstimate(
//         baseFee: baseFee,
//         prioritizationFee: prioritizationFee,
//         totalFee: totalFee,
//         totalFeeSol: totalFee / 1000000000,
//       );
//     } catch (e) {
//       // Fallback to a simple estimate if RPC call fails
//       final baseFee = 5000 * numSignatures;
//       return FeeEstimate(
//         baseFee: baseFee,
//         prioritizationFee: 0,
//         totalFee: baseFee,
//         totalFeeSol: baseFee / 1000000000,
//         isEstimated: true,
//       );
//     }
//   }
  
//   /// Get network fee tier information (min, median, max fees)
//   Future<FeeTiers?> getFeeTiers() async {
//     try {
//       // Get recent fees to calculate tiers
//       final recentFees = await getRecentPrioritizationFees();
//       if (recentFees.isEmpty) return null;
      
//       // Sort fees by priority
//       final List<int> feeValues = recentFees.map((f) => f.prioritizationFee).toList();
//       feeValues.sort();
      
//       final int len = feeValues.length;
      
//       return FeeTiers(
//         low: feeValues[len ~/ 10], // 10th percentile
//         medium: feeValues[len ~/ 2], // 50th percentile (median)
//         high: feeValues[(len * 8) ~/ 10], // 80th percentile
//       );
//     } catch (e) {
//       return null;
//     }
//   }
// }

// class PrioritizationFee {
//   final int slot;
//   final int prioritizationFee;
  
//   PrioritizationFee({
//     required this.slot,
//     required this.prioritizationFee,
//   });
  
//   Map<String, dynamic> toJson() {
//     return {
//       'slot': slot,
//       'prioritizationFee': prioritizationFee,
//     };
//   }
// }

// class FeeEstimate {
//   final int baseFee;
//   final int prioritizationFee;
//   final int totalFee;
//   final double totalFeeSol;
//   final bool isEstimated;
  
//   FeeEstimate({
//     required this.baseFee,
//     required this.prioritizationFee,
//     required this.totalFee,
//     required this.totalFeeSol,
//     this.isEstimated = false,
//   });
  
//   Map<String, dynamic> toJson() {
//     return {
//       'baseFee': baseFee,
//       'prioritizationFee': prioritizationFee,
//       'totalFee': totalFee,
//       'totalFeeSol': totalFeeSol,
//       'isEstimated': isEstimated,
//     };
//   }
// }

// class FeeTiers {
//   final int low;
//   final int medium;
//   final int high;
  
//   FeeTiers({
//     required this.low,
//     required this.medium,
//     required this.high,
//   });
  
//   Map<String, dynamic> toJson() {
//     return {
//       'low': low,
//       'medium': medium,
//       'high': high,
//     };
//   }
// }