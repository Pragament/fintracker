import 'dart:convert';
import 'dart:math';

class DataSanitizer {
  static final Random _random = Random();
  static final Map<String, String> _consistentRandomTexts = {};
  
  /// Sanitizes export data by removing/anonymizing PII
  static Map<String, dynamic> sanitizeExportData(Map<String, dynamic> data) {
    Map<String, dynamic> sanitizedData = {};
    
    // Sanitize accounts
    if (data.containsKey('accounts')) {
      sanitizedData['accounts'] = _sanitizeAccounts(data['accounts']);
    }
    
    // Sanitize categories (keep structure, sanitize names)
    if (data.containsKey('categories')) {
      sanitizedData['categories'] = _sanitizeCategories(data['categories']);
    }
    
    // Sanitize payments
    if (data.containsKey('payments')) {
      sanitizedData['payments'] = _sanitizePayments(data['payments']);
    }
    
    // Sanitize tags
    if (data.containsKey('tags')) {
      sanitizedData['tags'] = _sanitizeTags(data['tags']);
    }
    
    return sanitizedData;
  }
  
  static List<Map<String, dynamic>> _sanitizeAccounts(List<dynamic> accounts) {
    return accounts.map((account) {
      Map<String, dynamic> sanitized = Map<String, dynamic>.from(account);
      
      // Remove/anonymize PII fields
      sanitized['name'] = _getConsistentRandomText('account_${account['id']}', 'Account');
      sanitized['holderName'] = _maskString(account['holderName'] ?? '');
      sanitized['accountNumber'] = _maskAccountNumber(account['accountNumber'] ?? '');
      sanitized['upiId'] = account['upiId'] != null ? _maskEmail(account['upiId']) : null;
      
      // Keep non-PII fields
      // id, icon, color, isDefault, balance, income, expense remain unchanged
      
      return sanitized;
    }).toList();
  }
  
  static List<Map<String, dynamic>> _sanitizeCategories(List<dynamic> categories) {
    return categories.map((category) {
      Map<String, dynamic> sanitized = Map<String, dynamic>.from(category);
      
      // Sanitize category name but keep structure
      sanitized['name'] = _getConsistentRandomText('category_${category['id']}', 'Category');
      
      // Keep non-PII fields: id, icon, color, budget, expense
      
      return sanitized;
    }).toList();
  }
  
  static List<Map<String, dynamic>> _sanitizePayments(List<dynamic> payments) {
    return payments.map((payment) {
      Map<String, dynamic> sanitized = Map<String, dynamic>.from(payment);
      
      // Sanitize title and description
      sanitized['Title'] = _getConsistentRandomText('payment_title_${payment.hashCode}', 'Transaction');
      sanitized['Description'] = _getConsistentRandomText('payment_desc_${payment.hashCode}', 'Payment description');
      
      // Remove UPI transaction ID if present
      if (sanitized.containsKey('upi_transaction_id')) {
        sanitized['upi_transaction_id'] = sanitized['upi_transaction_id'] != null ? 
          'TXN${_random.nextInt(999999999).toString().padLeft(9, '0')}' : null;
      }
      
      // Keep non-PII fields: Amount, Type, Date, Debit, Credit, account, category references
      
      return sanitized;
    }).toList();
  }
  
  static List<Map<String, dynamic>> _sanitizeTags(List<dynamic> tags) {
    return tags.map((tag) {
      Map<String, dynamic> sanitized = Map<String, dynamic>.from(tag);
      
      // Sanitize tag name
      sanitized['name'] = _getConsistentRandomText('tag_${tag['id']}', 'Tag');
      
      // Keep non-PII fields: id, color, icon
      
      return sanitized;
    }).toList();
  }
  
  /// Generates consistent random text for the same key
  static String _getConsistentRandomText(String key, String prefix) {
    if (_consistentRandomTexts.containsKey(key)) {
      return _consistentRandomTexts[key]!;
    }
    
    String randomText = '${prefix}_${_generateRandomString(6)}';
    _consistentRandomTexts[key] = randomText;
    return randomText;
  }
  
  /// Masks a string by replacing characters with X
  static String _maskString(String input) {
    if (input.isEmpty) return '';
    if (input.length <= 2) return 'X' * input.length;
    
    return input[0] + 'X' * (input.length - 2) + input[input.length - 1];
  }
  
  /// Masks account number keeping first 2 and last 2 digits
  static String _maskAccountNumber(String accountNumber) {
    if (accountNumber.isEmpty) return '';
    if (accountNumber.length <= 4) return 'X' * accountNumber.length;
    
    return accountNumber.substring(0, 2) + 
           'X' * (accountNumber.length - 4) + 
           accountNumber.substring(accountNumber.length - 2);
  }
  
  /// Masks email keeping domain structure
  static String _maskEmail(String email) {
    if (!email.contains('@')) return _maskString(email);
    
    List<String> parts = email.split('@');
    String username = parts[0];
    String domain = parts[1];
    
    String maskedUsername = username.length > 2 ? 
      username[0] + 'X' * (username.length - 2) + username[username.length - 1] : 
      'X' * username.length;
    
    return '$maskedUsername@$domain';
  }
  
  /// Generates a random alphanumeric string
  static String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(_random.nextInt(chars.length))
    ));
  }
  
  /// Clears the consistent random text cache (useful for testing)
  static void clearCache() {
    _consistentRandomTexts.clear();
  }
}