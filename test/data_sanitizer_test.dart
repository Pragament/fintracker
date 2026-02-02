import 'package:flutter_test/flutter_test.dart';
import 'package:fintracker/helpers/data_sanitizer.dart';

void main() {
  group('DataSanitizer Tests', () {
    setUp(() {
      // Clear cache before each test to ensure consistency
      DataSanitizer.clearCache();
    });

    test('should sanitize account data removing PII', () {
      // Arrange
      Map<String, dynamic> testData = {
        'accounts': [
          {
            'id': 1,
            'name': 'John Doe Savings',
            'holderName': 'John Doe',
            'accountNumber': '1234567890',
            'upiId': 'john.doe@paytm',
            'icon': 12345,
            'color': 0xFF4CAF50,
            'isDefault': 1,
            'balance': 1000.0,
          }
        ]
      };

      // Act
      Map<String, dynamic> sanitized = DataSanitizer.sanitizeExportData(testData);
      Map<String, dynamic> sanitizedAccount = sanitized['accounts'][0];

      // Assert
      expect(sanitizedAccount['name'], startsWith('Account_'));
      expect(sanitizedAccount['holderName'], equals('JXXXXXXe')); // Masked
      expect(sanitizedAccount['accountNumber'], equals('12XXXXXX90')); // Masked
      expect(sanitizedAccount['upiId'], equals('jXXXXXXe@paytm')); // Email masked
      
      // Non-PII fields should remain unchanged
      expect(sanitizedAccount['id'], equals(1));
      expect(sanitizedAccount['icon'], equals(12345));
      expect(sanitizedAccount['color'], equals(0xFF4CAF50));
      expect(sanitizedAccount['isDefault'], equals(1));
      expect(sanitizedAccount['balance'], equals(1000.0));
    });

    test('should sanitize payment data removing titles and descriptions', () {
      // Arrange
      Map<String, dynamic> testData = {
        'payments': [
          {
            'Title': 'Grocery Shopping at Walmart',
            'Description': 'Weekly grocery shopping for family',
            'Amount': 150.50,
            'Type': 'Debit',
            'Date': '2023-12-01',
            'upi_transaction_id': 'UPI123456789',
          }
        ]
      };

      // Act
      Map<String, dynamic> sanitized = DataSanitizer.sanitizeExportData(testData);
      Map<String, dynamic> sanitizedPayment = sanitized['payments'][0];

      // Assert
      expect(sanitizedPayment['Title'], startsWith('Transaction_'));
      expect(sanitizedPayment['Description'], startsWith('Payment description_'));
      expect(sanitizedPayment['upi_transaction_id'], startsWith('TXN'));
      expect(sanitizedPayment['upi_transaction_id']?.length, equals(12)); // TXN + 9 digits
      
      // Non-PII fields should remain unchanged
      expect(sanitizedPayment['Amount'], equals(150.50));
      expect(sanitizedPayment['Type'], equals('Debit'));
      expect(sanitizedPayment['Date'], equals('2023-12-01'));
    });

    test('should sanitize category names while preserving structure', () {
      // Arrange
      Map<String, dynamic> testData = {
        'categories': [
          {
            'id': 1,
            'name': 'Personal Groceries',
            'icon': 12345,
            'color': 0xFF4CAF50,
            'budget': 500.0,
            'expense': 300.0,
          }
        ]
      };

      // Act
      Map<String, dynamic> sanitized = DataSanitizer.sanitizeExportData(testData);
      Map<String, dynamic> sanitizedCategory = sanitized['categories'][0];

      // Assert
      expect(sanitizedCategory['name'], startsWith('Category_'));
      
      // Non-PII fields should remain unchanged
      expect(sanitizedCategory['id'], equals(1));
      expect(sanitizedCategory['icon'], equals(12345));
      expect(sanitizedCategory['color'], equals(0xFF4CAF50));
      expect(sanitizedCategory['budget'], equals(500.0));
      expect(sanitizedCategory['expense'], equals(300.0));
    });

    test('should maintain consistency for same keys', () {
      // Arrange
      Map<String, dynamic> testData = {
        'accounts': [
          {
            'id': 1,
            'name': 'Test Account',
            'holderName': 'John Doe',
            'accountNumber': '1234567890',
          }
        ]
      };

      // Act - sanitize twice
      Map<String, dynamic> sanitized1 = DataSanitizer.sanitizeExportData(testData);
      Map<String, dynamic> sanitized2 = DataSanitizer.sanitizeExportData(testData);

      // Assert - should produce same results
      expect(sanitized1['accounts'][0]['name'], equals(sanitized2['accounts'][0]['name']));
    });

    test('should handle empty or null values gracefully', () {
      // Arrange
      Map<String, dynamic> testData = {
        'accounts': [
          {
            'id': 1,
            'name': '',
            'holderName': null,
            'accountNumber': '',
            'upiId': null,
          }
        ]
      };

      // Act
      Map<String, dynamic> sanitized = DataSanitizer.sanitizeExportData(testData);
      Map<String, dynamic> sanitizedAccount = sanitized['accounts'][0];

      // Assert - should not throw errors
      expect(sanitizedAccount['name'], startsWith('Account_'));
      expect(sanitizedAccount['holderName'], equals(''));
      expect(sanitizedAccount['accountNumber'], equals(''));
      expect(sanitizedAccount['upiId'], isNull);
    });
  });
}