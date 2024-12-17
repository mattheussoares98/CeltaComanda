enum PaymentMode {
  credit,
  creditPortion,
  debit,
  pix,
  voucher,
}

// Money = 1,
// Check = 2,
// PIX = 3,
// PurchaseVale = 4,
// DebitCard = 5,
// CreditCard = 6,
// Covenant = 7,
// POS = 8,
// Portion = 9,
// FinancialCredits = 10

extension PaymentModeExtension on PaymentMode {
  int get finalizationId {
    switch (this) {
      case PaymentMode.credit:
        return 6;
      case PaymentMode.creditPortion:
        return 6;
      case PaymentMode.debit:
        return 5;
      case PaymentMode.pix:
        return 3;
      case PaymentMode.voucher:
        return 5;
    }
  }
}
