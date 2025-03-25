import 'package:solana_utils/solana_utils.dart';

void main() async {
  // Basic validation
  bool isValidAddress = SolanaUtils.isValidAddress(
    'Gh9ZwEmdLJ8DscKNTkTqPbNwLNNBjuSzaG9Vp2KGtKJr',
  );
  print('Is valid address: $isValidAddress');
  bool isValidSignature = SolanaUtils.isValidSignature(
    '3tHvhETSSR9GnumxQTsvEqjX1hHMzAKN6mEJj4LXHucUACk2JESXvDB8vdzNmxM8vJzTSPct5zs63tU9ifNtB8vn',
  );
  print('Is valid signature: $isValidSignature');

  // Formatting
  String shortAddress = SolanaUtils.formatAddress(
    'Gh9ZwEmdLJ8DscKNTkTqPbNwLNNBjuSzaG9Vp2KGtKJr',
  ); // Gh9Z...tKJr
  print('Short address: $shortAddress');
  String shortSig = SolanaUtils.formatSignature(
    '5KT3cmxBswmY9PYc5qWj5N7jnhqFv1PNqgwxMXaQEP3u1MnkY5CT9fDNMJPY8qzFXhuZckerLRHYu8qo6T1FfM5P',
  ); // 5KT3cmx...T1FfM5P
  print('Short signature: $shortSig');

  // Transaction details
  void fetchTransaction() async {
    final txn = await SolanaUtils.getTransactionDetails(
      '4QhLJQvJYvg2LVMgE7Mo3YkHt6n11Z6nGu7PbrPiZg37muG7mQKKMqyV7Bh9vRZ2sHNP4e5dDWrzzJ1WfZNEybCR',
      useMainnet: true,
    );

    if (txn != null) {
      print('Transaction succeeded: ${txn.success}');
      print('Slot: ${txn.rawJson}');
      print('Fee: ${txn.feeSol} SOL');
      print('Block time: ${txn.blockTime}');
    } else {
      print('Transaction not found');
    }
  }

  fetchTransaction();
}
/*

txn.rawJson looks like this 👇


Slot: {
blockTime: 1742777404,
meta: {
  computeUnitsConsumed: 300,
  err: null,
  fee: 8000, 
  innerInstructions: [], 
  loadedAddresses: {
    readonly: [], 
    writable: []}, 
    logMessages: [
      Program 11111111111111111111111111111111 invoke [1],
      Program 11111111111111111111111111111111 success, 
      Program ComputeBudget111111111111111111111111111111 invoke [1], 
      Program ComputeBudget111111111111111111111111111111 success
    ], 
  postBalances: [
    63226735117224, 
    245072111, 
    1, 
    1], 
  postTokenBalances: [],
  preBalances: [
    63226978197335, 
    2000000, 
    1, 
    1], 
  preTokenBalances: [], 
  rewards: [], 
  status: {
    Ok: null
    }
  }, 
  slot: 328760882, 
  transaction: {
    message: {
      accountKeys: [
        2AQdpHJ2JpcEgPiATUXjQxA8QmafFegfQwSLWSprPicm, 
        RBTVb71jUhV1WeMk6FnAqsTPcxPj2eF1y3azHJaBpEi, 
        11111111111111111111111111111111, 
        ComputeBudget111111111111111111111111111111
      ], 
    header: {
      numReadonlySignedAccounts: 0, 
      numReadonlyUnsignedAccounts: 2, 
      numRequiredSignatures: 1
    }, 
    instructions: [
      {
        accounts: [0, 1], 
        data: 3Bxs4Kb4rtUYDSej, 
        programIdIndex: 2, 
        stackHeight: 
        null
      }, 
      {accounts: [], 
      data: 3Jv73z5Y9SRV, 
      programIdIndex: 3, 
      stackHeight: null
      }
    ], 
    recentBlockhash: ED5Y9DC4srJxmcFtYFV9qbp2XZnvBYJXNFmSDA5nN2QU}, 
    signatures: [
      4QhLJQvJYvg2LVMgE7Mo3YkHt6n11Z6nGu7PbrPiZg37muG7mQKKMqyV7Bh9vRZ2sHNP4e5dDWrzzJ1WfZNEybCR
    ]
  }, 
  version: legacy
}
*/