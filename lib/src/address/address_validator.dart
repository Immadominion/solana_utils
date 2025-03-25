 

class SolanaAddressValidator {
  // Base58 character set for Solana addresses
  static const String _base58Chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  
  // Regular format check for Solana addresses (base58 encoded, 32-44 chars)
  static bool isValidFormat(String address) {
    if (address.isEmpty) return false;
    
    // Check length
    if (address.length < 32 || address.length > 44) return false;
    
    // Check for invalid characters
    for (int i = 0; i < address.length; i++) {
      if (!_base58Chars.contains(address[i])) {
        return false;
      }
    }
    
    return true;
  }
  
  // Validate if the address follows ED25519 program derived addresses pattern
  static bool isProgramDerivedAddress(String address) {
    return isValidFormat(address) && address.startsWith('1');
  }
  
  // Format address with ellipsis for display
  static String formatForDisplay(String address) {
    if (!isValidFormat(address)) return 'Invalid Address';
    if (address.length <= 11) return address;
    
    return '${address.substring(0, 4)}...${address.substring(address.length - 4)}';
  }
  
  // Normalize address: trim whitespace and check validity
  static String? normalizeAddress(String? rawAddress) {
    if (rawAddress == null) return null;
    
    final trimmed = rawAddress.trim();
    return isValidFormat(trimmed) ? trimmed : null;
  }
}