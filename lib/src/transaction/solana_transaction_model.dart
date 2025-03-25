class SolanaTransaction {
  final String signature;
  final int slot;
  final DateTime? blockTime;
  final String? blockHash;
  final List<String> accountKeys;
  final bool success;
  final int lamportFee;
  final String? errorMessage;
  final Map<String, dynamic> rawJson;
  
  SolanaTransaction({
    required this.signature,
    required this.slot,
    this.blockTime,
    this.blockHash,
    required this.accountKeys,
    required this.success,
    required this.lamportFee,
    this.errorMessage,
    required this.rawJson,
  });
  
  factory SolanaTransaction.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] ?? {};
    final transaction = json['transaction'] ?? {};
    final message = transaction['message'] ?? {};
    
    // Extract account keys
    final List<dynamic> keysJson = message['accountKeys'] ?? [];
    final List<String> keys = keysJson.map((k) => k.toString()).toList();
    
    // Convert block time to DateTime if available
    DateTime? blockTimeObj;
    if (json['blockTime'] != null) {
      blockTimeObj = DateTime.fromMillisecondsSinceEpoch(
        (json['blockTime'] as int) * 1000
      );
    }
    
    return SolanaTransaction(
      signature: json['transaction']['signatures'][0] ?? '',
      slot: json['slot'] ?? 0,
      blockTime: blockTimeObj,
      blockHash: json['blockHash'] ?? '',
      accountKeys: keys,
      success: meta['err'] == null,
      lamportFee: meta['fee'] ?? 0,
      errorMessage: meta['err']?.toString(),
      rawJson: json,
    );
  }
  
  // Helper to get SOL amount from lamports
  double get feeSol => lamportFee / 1000000000;
  
  // Get transaction age in seconds
  int? get age {
    if (blockTime == null) return null;
    return DateTime.now().difference(blockTime!).inSeconds;
  }
  
  // Check if transaction is older than given duration
  bool isOlderThan(Duration duration) {
    if (blockTime == null) return false;
    return DateTime.now().difference(blockTime!) > duration;
  }
  
  Map<String, dynamic> toDisplayJson() {
    return {
      'signature': signature,
      'status': success ? 'Success' : 'Failed',
      'blockTime': blockTime?.toIso8601String(),
      'fee': '$feeSol SOL',
      'error': errorMessage,
      'accounts': accountKeys.take(5).toList(),
      'totalAccounts': accountKeys.length,
    };
  }
}