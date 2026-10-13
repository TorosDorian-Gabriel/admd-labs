class BankAccount {
  late String accountNumber;
  String holderName;
  double balance;
  String? bankBranch;
  BankAccount({
    required this.accountNumber,
    required this.holderName,
    this.balance = 0.0,
    this.bankBranch,
  });
  BankAccount initializeAccount(String number){
    return BankAccount(accountNumber: number, holderName: "name", balance: 0.0);
  }
  String checkNumber(BankAccount account) {
    if (account.accountNumber.length != 16){
      return "Account number is invalid";
    }
    return "Account number is valid";
  }
}
