import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/attendance_model.dart';

class MyExcelSheet extends StatefulWidget {
  @override
  State<MyExcelSheet> createState() => _MyExcelSheetState();
}

class _MyExcelSheetState extends State<MyExcelSheet> {
  static const platform = MethodChannel('exampleMethod');

  @override
  void initState() {
    fetchData();
    super.initState();
  }

// Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      // final String result = await platform.invokeMethod('getSensor');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<List<AttendanceModel>> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://92.204.170.104:9889/EmployeeAttendanceDetailWithStartAndEndDateERPV3PDF/19/2023-07-28T00%3A00%3A00/2023-08-28T00%3A00%3A00'));
    if (response.statusCode == 200) {
      print('_MyExcelSheetState.fetchData Respose: ${response.body}');
      final List<dynamic> jsonData = json.decode(response.body);
      final List<AttendanceModel> data = jsonData.map((item) {
        return AttendanceModel(
          employeeId: item['employee_id'],
          employeeName: item['employee_name'],
          attendanceStatus: item['attendance_status'] == "ABS" ? "A" : "P",
          transactionDate: item['transaction_date'],
          weekday: item['weekday'],
          recordedTimeIn: item['recorded_time_in'],
        );
      }).toList();
      setState(() {});
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> writeExcel(List<AttendanceModel> data) async {
    final excel = Excel.createExcel();

    // Adding headers
    // sheet.appendRow(['Name', 'email']);
    excel.updateCell('Sheet1', CellIndex.indexByString('A1'), 'Employee ID',
        cellStyle: CellStyle(
            backgroundColorHex: "#3d3d3d",
            fontColorHex: 'ffffff',
            bold: true,
            verticalAlign: VerticalAlign.Center));

    excel.updateCell('Sheet1', CellIndex.indexByString('B1'), 'Employee Name',
        cellStyle: CellStyle(
            backgroundColorHex: "#3d3d3d",
            fontColorHex: 'ffffff',
            bold: true,
            verticalAlign: VerticalAlign.Center));
    excel.updateCell(
        'Sheet1', CellIndex.indexByString('C1'), 'Transaction Date',
        cellStyle: CellStyle(
            backgroundColorHex: "#3d3d3d",
            fontColorHex: 'ffffff',
            bold: true,
            verticalAlign: VerticalAlign.Center));

    excel.updateCell(
        'Sheet1', CellIndex.indexByString('D1'), 'Attendance Status',
        cellStyle: CellStyle(
            backgroundColorHex: "#3d3d3d",
            fontColorHex: 'ffffff',
            bold: true,
            verticalAlign: VerticalAlign.Center));

    final sheet = excel['Sheet1'];
    excel.insertColumn('Sheet1', 4);

    // Adding data
    try {
      for (final item in data) {
        sheet.appendRow([
          item.employeeId,
          item.employeeName,
          item.transactionDate,
          item.attendanceStatus
        ]);
      }

      // Save the Excel file
      final Directory? documentsDirectory = await getExternalStorageDirectory();
      final String path = '${documentsDirectory!.path}/attendance1.xlsx';

      final fileBytes = excel.encode();
      final File file = File(path);
      await file.writeAsBytes(fileBytes!);
      print("Status: ${file}");
      // OpenFile.open(file.path);
    } catch (e) {
      print('_MyExcelSheetState.writeExcel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Excel Export Example')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _getBatteryLevel,
            child: const Text('Get Battery Level'),
          ),
          Text(_batteryLevel),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                List<AttendanceModel> data = await fetchData();
                await writeExcel(data);
              },
              child: Text('Export to Excel'),
            ),
          ),
        ],
      ),
    );
  }
}
