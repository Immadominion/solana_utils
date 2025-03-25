class SolanaSignatureValidator {
  // Base58 character set
  static const String _base58Chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  
  // Standard Solana signature is 88 characters in base58 encoding
  static bool isValidFormat(String signature) {
    if (signature.isEmpty) return false;
    
    // Check length (typical signatures are 87-88 characters)
    if (signature.length < 87 || signature.length > 88) return false;
    
    // Check for invalid characters
    for (int i = 0; i < signature.length; i++) {
      if (!_base58Chars.contains(signature[i])) {
        return false;
      }
    }
    
    return true;
  }
  
  // Format signature with ellipsis for display
  static String formatForDisplay(String signature) {
    if (!isValidFormat(signature)) return 'Invalid Signature';
    
    return '${signature.substring(0, 7)}...${signature.substring(signature.length - 7)}';
  }
  
  // Normalize signature: trim whitespace and check validity
  static String? normalizeSignature(String? rawSignature) {
    if (rawSignature == null) return null;
    
    final trimmed = rawSignature.trim();
    return isValidFormat(trimmed) ? trimmed : null;
  }
}