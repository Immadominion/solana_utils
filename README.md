# Solana Utils

**Solana Utils** is a Dart package that provides essential utilities for interacting with the Solana blockchain. It includes address validation, transaction signature validation, transaction details retrieval, and formatting tools.

## Features

This package provides the following functionalities:

### ✅ Address Validation
- Checks if a Solana address follows the correct format.

### ✅ Transaction Signature Validation
- Validates if a transaction signature is properly formatted.

### ✅ Transaction Details Fetching
- Retrieves transaction details from either **Solana mainnet** or **devnet**.

### 🔜 Upcoming Features
- Token balance checker
- SPL token metadata fetcher
- Program account data parser
- RPC endpoint health checker
- Gas fee estimator
- Wallet key pair generator

These additions will assist Solana developers in common blockchain tasks while building their applications. Our goal is to implement all the possible utilities devs would have while developing on Solana, so if you have one in mind or have implemented one previously, reach out and we'd be happy to add it. 

---

## Installation

Add `solana_utils` to your project's dependencies:

```yaml
dependencies:
  solana_utils: latest_version
```

Then, run:

```sh
flutter pub get
```

---

## Usage

### Importing the Package

```dart
import 'package:solana_utils/solana_utils.dart';
```

### 1. Address Validation

```dart
void main() {
  bool isValidAddress = SolanaUtils.isValidAddress(
    'Gh9ZwEmdLJ8DscKNTkTqPbNwLNNBjuSzaG9Vp2KGtKJr',
  );
  print('Is valid address: $isValidAddress');
}
```

### 2. Transaction Signature Validation

```dart
void main() {
  bool isValidSignature = SolanaUtils.isValidSignature(
    '3tHvhETSSR9GnumxQTsvEqjX1hHMzAKN6mEJj4LXHucUACk2JESXvDB8vdzNmxM8vJzTSPct5zs63tU9ifNtB8vn',
  );
  print('Is valid signature: $isValidSignature');
}
```

### 3. Formatting Addresses and Signatures

```dart
void main() {
  String shortAddress = SolanaUtils.formatAddress(
    'Gh9ZwEmdLJ8DscKNTkTqPbNwLNNBjuSzaG9Vp2KGtKJr',
  ); // Output: Gh9Z...tKJr
  print('Short address: $shortAddress');

  String shortSig = SolanaUtils.formatSignature(
    '5KT3cmxBswmY9PYc5qWj5N7jnhqFv1PNqgwxMXaQEP3u1MnkY5CT9fDNMJPY8qzFXhuZckerLRHYu8qo6T1FfM5P',
  ); // Output: 5KT3cmx...T1FfM5P
  print('Short signature: $shortSig');
}
```

### 4. Fetching Transaction Details

```dart
void main() async {
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
```

---

## Example Transaction Response

When you fetch transaction details, the rawJson response may look like this:

```json
{
  "blockTime": 1742777404,
  "meta": {
    "computeUnitsConsumed": 300,
    "err": null,
    "fee": 8000,
    "logMessages": [
      "Program 11111111111111111111111111111111 invoke [1]",
      "Program 11111111111111111111111111111111 success"
    ],
    "preBalances": [
      63226978197335, 2000000, 1, 1
    ],
    "postBalances": [
      63226735117224, 245072111, 1, 1
    ]
  },
  "slot": 328760882,
  "transaction": {
    "signatures": [
      "4QhLJQvJYvg2LVMgE7Mo3YkHt6n11Z6nGu7PbrPiZg37muG7mQKKMqyV7Bh9vRZ2sHNP4e5dDWrzzJ1WfZNEybCR"
    ]
  }
}
```

---

## Future Plans

Planned features include:

- **Token balance checker**: Retrieve token balances for a given address.
- **SPL token metadata fetcher**: Fetch metadata details for SPL tokens.
- **Program account data parser**: Read and parse on-chain account data.
- **RPC endpoint health checker**: Monitor Solana RPC node performance.
- **Gas fee estimator**: Estimate transaction fees before submission.
- **Wallet key pair generator**: Generate secure Solana wallets.

---

## Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

To contribute:
1. Fork the repository
2. Create a new branch (`feature-branch`)
3. Commit your changes
4. Push to your branch
5. Submit a pull request

---

## License

This project is licensed under the MIT License.

---

## Contact

For questions or support, open an issue or reach out via [GitHub](https://github.com/Immadominion/solana_utils).

Happy coding! 🚀

