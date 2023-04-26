class LoanDto {
  String sId;
  LoanUser borrower;
  LoanUser? lender;
  int amount;
  String status;
  String startTime;

  LoanDto(
      { required this.sId,
        required this.borrower,
        required this.lender,
        required this.amount,
        required this.status,
        required this.startTime});

  factory LoanDto.fromJson(Map<String, dynamic> json) {
    return LoanDto(
    sId : json['_id'],
    borrower : LoanUser.fromJson(json['borrower']),
    lender : json['lender'] != null ? new LoanUser.fromJson(json['lender']) : null,
    amount : json['amount'],
    status : json['status'],
    startTime : json['start_time'] ?? "",
    );
  }

}

class LoanUser {
  String sId;
  String name;
  String email;
  String userId;
  String upiId;

  LoanUser(
      { required this.sId,
        required this.name,
        required this.email,
        required this.userId,
        required this.upiId,
      });

  factory LoanUser.fromJson(Map<String, dynamic> json) {
    return LoanUser(
        sId : json['_id'],
        name : json['name'],
        email : json['email'],
        userId : json['user_id'],
        upiId : json['upi_id'],
    );
  }

}
