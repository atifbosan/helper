class AttendanceModel {
  String? employeeName;
  String? employeeId;
  String? transactionDate;
  String? attendanceStatus;
  String? weekday;
  String? recordedTimeIn;

  AttendanceModel(
      {this.employeeName,
      this.employeeId,
      this.transactionDate,
      this.attendanceStatus,
      this.weekday,
      this.recordedTimeIn});

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    employeeName = json['employee_name'];
    employeeId = json['employee_id'];
    transactionDate = json['transaction_date'];
    attendanceStatus = json['attendance_status'];
    weekday = json['weekday'];
    recordedTimeIn = json['recorded_time_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_name'] = this.employeeName;
    data['employee_id'] = this.employeeId;
    data['transaction_date'] = this.transactionDate;
    data['attendance_status'] = this.attendanceStatus;
    data['weekday'] = this.weekday;
    data['recorded_time_in'] = this.recordedTimeIn;
    return data;
  }
}
