// import 'dart:async';
// import 'package:solana_utils/src/rpc/rpc_constants.dart';

// import '../rpc/rpc_client.dart';

// class SolanaRpcHealthChecker {
//   final Map<String, SolanaRpcClient> _endpoints;
//   Timer? _monitorTimer;
  
//   // Standard endpoints
//   static const Map<String, String> DEFAULT_ENDPOINTS = {
//     'Mainnet': SolanaRpcConstants.mainnetUrl,
//     'Devnet': SolanaRpcConstants.devnetUrl,
//     'Testnet': SolanaRpcConstants.testnetUrl,
//   };
  
//   SolanaRpcHealthChecker({
//     Map<String, String>? customEndpoints,
//   }) : _endpoints = {} {
//     // Initialize with default endpoints
//     DEFAULT_ENDPOINTS.forEach((name, url) {
//       _endpoints[name] = SolanaRpcClient(
//         endpoint: url,
//         timeout: Duration(seconds: 5),
//       );
//     });
    
//     // Add any custom endpoints
//     customEndpoints?.forEach((name, url) {
//       _endpoints[name] = SolanaRpcClient(
//         endpoint: url,
//         timeout: Duration(seconds: 5),
//       );
//     });
//   }
  
//   /// Check a single endpoint's health
//   Future<EndpointHealth> checkEndpoint(String endpointName) async {
//     if (!_endpoints.containsKey(endpointName)) {
//       return EndpointHealth(
//         name: endpointName,
//         url: 'unknown',
//         isHealthy: false,
//         latencyMs: 0,
//         height: 0,
//         error: 'Endpoint not configured',
//       );
//     }
    
//     final client = _endpoints[endpointName]!;
//     final stopwatch = Stopwatch()..start();
    
//     try {
//       // Get block height and version in parallel
//       final results = await Future.wait([
//         client.call('getBlockHeight', []),
//         client.call('getVersion', []),
//       ]);
      
//       stopwatch.stop();
//       final blockHeight = results[0]['result'];
//       final version = results[1]['result']['solana-core'];
      
//       return EndpointHealth(
//         name: endpointName,
//         url: client.endpoint,
//         isHealthy: true,
//         latencyMs: stopwatch.elapsedMilliseconds,
//         height: blockHeight,
//         version: version,
//       );
//     } catch (e) {
//       stopwatch.stop();
//       return EndpointHealth(
//         name: endpointName,
//         url: client.endpoint,
//         isHealthy: false,
//         latencyMs: stopwatch.elapsedMilliseconds,
//         height: 0,
//         error: e.toString(),
//       );
//     }
//   }
  
//   /// Check health of all configured endpoints
//   Future<Map<String, EndpointHealth>> checkAllEndpoints() async {
//     final Map<String, EndpointHealth> results = {};
//     final futures = _endpoints.keys.map((name) async {
//       final health = await checkEndpoint(name);
//       results[name] = health;
//     });
    
//     await Future.wait(futures);
//     return results;
//   }
  
//   /// Start periodic monitoring of endpoints
//   void startMonitoring({
//     Duration interval = const Duration(minutes: 1),
//     Function(Map<String, EndpointHealth>)? callback,
//   }) {
//     stopMonitoring();
    
//     _monitorTimer = Timer.periodic(interval, (_) async {
//       final results = await checkAllEndpoints();
//       if (callback != null) {
//         callback(results);
//       }
//     });
//   }
  
//   /// Stop periodic monitoring
//   void stopMonitoring() {
//     _monitorTimer?.cancel();
//     _monitorTimer = null;
//   }
  
//   /// Find best endpoint based on latency
//   Future<String?> findBestEndpoint() async {
//     final results = await checkAllEndpoints();
    
//     // Filter healthy endpoints
//     final healthyEndpoints = results.values.where((health) => health.isHealthy);
//     if (healthyEndpoints.isEmpty) return null;
    
//     // Find the one with lowest latency
//     final bestEndpoint = healthyEndpoints.reduce(
//       (a, b) => a.latencyMs < b.latencyMs ? a : b
//     );
    
//     return bestEndpoint.name;
//   }
// }

// class EndpointHealth {
//   final String name;
//   final String url;
//   final bool isHealthy;
//   final int latencyMs;
//   final int height;
//   final String? version;
//   final String? error;
  
//   EndpointHealth({
//     required this.name,
//     required this.url,
//     required this.isHealthy,
//     required this.latencyMs,
//     required this.height,
//     this.version,
//     this.error,
//   });
  
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'url': url,
//       'isHealthy': isHealthy,
//       'latencyMs': latencyMs,
//       'height': height,
//       'version': version,
//       'error': error,
//     };
//   }
// }