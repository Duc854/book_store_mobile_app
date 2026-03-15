import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/admin_stats.dart';

class AdminStatsService {

  static const baseUrl="http://localhost:7128/api/admin/stats";

  static Future<AdminStats> getStats() async{

    final res=await http.get(Uri.parse(baseUrl));

    if(res.statusCode==200){

      return AdminStats.fromJson(jsonDecode(res.body));

    }else{

      throw Exception("Failed to load stats");

    }
  }

}