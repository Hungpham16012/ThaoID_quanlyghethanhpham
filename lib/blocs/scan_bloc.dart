import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:ghethanhpham_thaco/models/scan.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';

class ScanBloc extends ChangeNotifier {
  static RequestHelper requestHelper = RequestHelper();

  ScanModel? _data;
  ScanModel? get data => _data;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _success = false;
  bool get success => _success;

  String? _message;
  String? get message => _message;

  Future getData(String qrCode, bool isNhapKho) async {
    _isLoading = true;
    _data = null;
    try {
      final http.Response response = await requestHelper
          .getData('Mobile/ThongTin?Qrcode=$qrCode&IsNhapKho=$isNhapKho');
      var decodedData = jsonDecode(response.body);
      if (decodedData["data"] != null) {
        _data = ScanModel.fromJson(decodedData["data"]);
      } else {
        _data = null;
      }

      _isLoading = false;
      _success = decodedData["success"];
      _message = decodedData["message"];
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future postData(ScanModel scanData) async {
    _isLoading = true;
    try {
      var newScanData = scanData;
      newScanData.chuyenId =
          (newScanData.chuyenId == 'null' ? null : newScanData.chuyenId)!;
      final http.Response response =
          await requestHelper.postData('Mobile/ThongTin', newScanData.toJson());
      var decodedData = jsonDecode(response.body);
      _isLoading = false;
      _success = decodedData["success"];
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
