// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:convert';

// /// A simple keypair generator for Solana
// /// Note: This is a simplified implementation that avoids crypto dependencies
// /// In a production environment, you'd use proper ed25519 libraries
// class SolanaKeypairGenerator {
//   // Base58 alphabet for encoding
//   static const String _base58Chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  
//   final Random _random;
  
//   SolanaKeypairGenerator({Random? random}) 
//       : _random = random ?? Random.secure();
  
//   /// Generate a new keypair
//   SolanaKeypair generateKeypair() {
//     // Generate 32 random bytes for the seed (for ed25519 private key)
//     final seedBytes = List<int>.generate(32, (_) => _random.nextInt(256));
    
//     // In a real implementation, you'd use proper ed25519 key derivation
//     // This is a simplified approximation using the seed to derive a "public key"
//     final List<int> publicKeyBytes = _derivePublicKey(seedBytes);
    
//     // Convert the public key to a Solana address (base58 encoded)
//     final publicKey = _encodeBase58(publicKeyBytes);
    
//     // The private key would normally be the seed plus the derived public key bytes
//     final privateKeyBytes = [...seedBytes, ...publicKeyBytes];
//     final privateKey = _encodeBase58(privateKeyBytes);
    
//     return SolanaKeypair(
//       publicKey: publicKey,
//       privateKey: privateKey,
//       seedBytes: Uint8List.fromList(seedBytes),
//     );
//   }
  
//   /// Generate a keypair from an existing seed
//   SolanaKeypair fromSeed(Uint8List seed) {
//     if (seed.length != 32) {
//       throw ArgumentError('Seed must be 32 bytes');
//     }
    
//     // Same simplified approach as above
//     final List<int> publicKeyBytes = _derivePublicKey(seed);
//     final publicKey = _encodeBase58(publicKeyBytes);
    
//     final privateKeyBytes = [...seed, ...publicKeyBytes];
//     final privateKey = _encodeBase58(privateKeyBytes);
    
//     return SolanaKeypair(
//       publicKey: publicKey,
//       privateKey: privateKey,
//       seedBytes: seed,
//     );
//   }
  
//   /// Generate keypair from a mnemonic phrase
//   /// Note: In a real implementation, you'd use BIP39 derivation
//   SolanaKeypair fromMnemonic(String mnemonic) {
//     // Simple hash of the mnemonic for demo purposes
//     // In production, use proper BIP39 derivation
//     final bytes = utf8.encode(mnemonic);
//     final hash = _simpleHash(bytes);
    
//     // Ensure we have 32 bytes
//     final seedBytes = Uint8List(32);
//     for (int i = 0; i < hash.length && i < 32; i++) {
//       seedBytes[i] = hash[i];
//     }
    
//     return fromSeed(seedBytes);
//   }
  
//   /// Generate a random mnemonic phrase (simplified)
//   String generateMnemonic({int wordCount = 12}) {
//     // In a real implementation, you'd use a proper BIP39 library
//     // This is a simplified version using basic English words
//     const words = [
//       'abandon', 'ability', 'able', 'about', 'above', 'absent', 'absorb', 'abstract',
//       'absurd', 'abuse', 'access', 'accident', 'account', 'accuse', 'achieve', 'acid',
//       'acoustic', 'acquire', 'across', 'act', 'action', 'actor', 'actress', 'actual',
//       'adapt', 'add', 'addict', 'address', 'adjust', 'admit', 'adult', 'advance',
//       'advice', 'aerobic', 'affair', 'afford', 'afraid', 'again', 'age', 'agent',
//       'agree', 'ahead', 'aim', 'air', 'airport', 'aisle', 'alarm', 'album',
//       'alcohol', 'alert', 'alien', 'all', 'alley', 'allow', 'almost', 'alone',
//       'alpha', 'already', 'also', 'alter', 'always', 'amateur', 'amazing', 'among',
//       // In a real implementation, you'd have all 2048 BIP39 words
//     ];
    
//     final randomIndices = List<int>.generate(
//       wordCount, 
//       (_) => _random.nextInt(words.length)
//     );
    
//     return randomIndices.map((i) => words[i]).join(' ');
//   }
  
//   /// Simple base58 encoding implementation
//   String _encodeBase58(List<int> bytes) {
//     BigInt value = BigInt.zero;
    
//     // Convert bytes to a big integer
//     for (final byte in bytes) {
//       value = value * BigInt.from(256) + BigInt.from(byte);
//     }
    
//     // Convert the integer to base58
//     String result = '';
//     while (value > BigInt.zero) {
//       final remainder = (value % BigInt.from(58)).toInt();
//       result = _base58Chars[remainder] + result;
//       value = value ~/ BigInt.from(58);
//     }
    
//     // Add leading '1's for leading zeros in the byte array
//     for (int i = 0; i < bytes.length && bytes[i] == 0; i++) {
//       result = '1' + result;
//     }
    
//     return result;
//   }
  
//   /// Simple base58 decoding implementation
//   Uint8List _decodeBase58(String encoded) {
//     BigInt value = BigInt.zero;
    
//     // Convert base58 string to big integer
//     for (int i = 0; i < encoded.length; i++) {
//       final charIndex = _base58Chars.indexOf(encoded[i]);
//       if (charIndex < 0) {
//         throw FormatException('Invalid base58 character: ${encoded[i]}');
//       }
//       value = value * BigInt.from(58) + BigInt.from(charIndex);
//     }
    
//     // Convert to bytes
//     final bytes = <int>[];
//     while (value > BigInt.zero) {
//       bytes.insert(0, (value % BigInt.from(256)).toInt());
//       value = value ~/ BigInt.from(256);
//     }
    
//     // Add leading zeros
//     for (int i = 0; i < encoded.length && encoded[i] == '1'; i++) {
//       bytes.insert(0, 0);
//     }
    
//     return Uint8List.fromList(bytes);
//   }
  
//   /// A simple hash function for demonstration
//   /// In a real implementation, you'd use a cryptographic hash function
//   List<int> _simpleHash(List<int> data) {
//     final result = List<int>.filled(32, 0);
    
//     for (int i = 0; i < data.length; i++) {
//       result[i % 32] = (result[i % 32] + data[i]) % 256;
//     }
    
//     // Additional mixing to improve distribution
//     for (int i = 0; i < 32; i++) {
//       result[i] = (result[i] + result[(i + 1) % 32]) % 256;
//     }
    
//     return result;
//   }
  
//   /// Derive a public key from a private key seed
//   /// Note: This is a simplified approximation. In a real implementation,
//   /// you'd use proper ed25519 key derivation
//   List<int> _derivePublicKey(List<int> seed) {
//     // This is not cryptographically correct - just a demonstration
//     // Real implementations would use the ed25519 curve operations
//     final publicKey = List<int>.filled(32, 0);
    
//     // Create a simple deterministic pattern based on the seed
//     for (int i = 0; i < 32; i++) {
//       int value = seed[i];
//       // Apply some mixing to distribute the bits
//       for (int j = 0; j < 32; j++) {
//         value = ((value * 1103515245) + 12345) % 256;
//         publicKey[j] = (publicKey[j] + value) % 256;
//       }
//     }
    
//     return publicKey;
//   }
// }

// /// Represents a Solana keypair
// class SolanaKeypair {
//   /// The public key (Solana address) in base58 encoding
//   final String publicKey;
  
//   /// The private key in base58 encoding
//   final String privateKey;
  
//   /// The original seed bytes
//   final Uint8List seedBytes;
  
//   SolanaKeypair({
//     required this.publicKey,
//     required this.privateKey,
//     required this.seedBytes,
//   });
  
//   @override
//   String toString() => 'SolanaKeypair(publicKey: $publicKey)';
  
//   /// Export keypair as a JSON string
//   String toJson() {
//     final map = {
//       'publicKey': publicKey,
//       'privateKey': privateKey,
//     };
//     return jsonEncode(map);
//   }
  
//   /// Create a keypair from a JSON string
//   static SolanaKeypair fromJson(String jsonString, SolanaKeypairGenerator generator) {
//     final map = jsonDecode(jsonString) as Map<String, dynamic>;
//     final privateKey = map['privateKey'] as String;
    
//     // In a proper implementation, you'd extract the seed from the private key
//     // For this demo, we'll create a new keypair with random seed
//     // This is not correct for a real application
//     return generator.generateKeypair();
//   }
// }