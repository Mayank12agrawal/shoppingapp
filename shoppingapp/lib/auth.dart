import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './http_exception.dart';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String userId;
   Timer _authtimer;

  bool get isAuth{
    return token!=null;
  }

  String get token{
    if(_expiryDate!=null && _expiryDate.isAfter(DateTime.now())&& _token!=null){
      return _token;
    }
    return null;
  }
  String get userid{
    return userId;
  }
  Future<void>signup(String email,String password) async{
    const url='https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDijVaIpU3l1Q13Yx4_cesJUjxTdozY2kI';
    try{
      final response=await http.post(url,body:
      json.encode({
        'email':email,
        'password':password,
        'returnSecureToken':true,
      })
      );
      final responsedata=json.decode(response.body);
      if(responsedata['error']!=null)
        {
         throw HttpException(responsedata['error']['message']);
        }
      _token=responsedata['idToken'];
      userId=responsedata['localId'];
      _expiryDate=DateTime.now().add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      autologout();
      notifyListeners();
      final prefs=await SharedPreferences.getInstance();
      final userdata=json.encode({
        'token':_token,
        'userId':userId,
        'expiryDate':_expiryDate.toIso8601String(),
      });
      prefs.setString('userdata', userdata);
    }catch(error)
    {
      throw error;
    }


  }

  Future<void>login(String email,String password) async{
    const url='https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDijVaIpU3l1Q13Yx4_cesJUjxTdozY2kI';
    try{
      final response=await http.post(url,body:
      json.encode({
        'email':email,
        'password':password,
        'returnSecureToken':true,
      })
      );
      final responsedata=json.decode(response.body);
      print(responsedata);
      if(responsedata['error']!=null)
      {
        throw HttpException(responsedata['error']['message']);
      }
      _token=responsedata['idToken'];
      userId=responsedata['localId'];
      _expiryDate=DateTime.now().add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      autologout();
      notifyListeners();
      final prefs=await SharedPreferences.getInstance();
      final userdata=json.encode({
        'token':_token,
        'userId':userId,
        'expiryDate':_expiryDate.toIso8601String(),
      });
      prefs.setString('userdata', userdata);
    }catch(error)
    {
      throw error;
    }


  }
  Future<bool> autologin()async{
    final prefs=await SharedPreferences.getInstance();
    if(!prefs.containsKey('userdata'))
      {
        return false;
      }
    final extractedfdata=json.decode(prefs.getString('userdata')) as Map<String,Object>;
    final expiryDate=DateTime.parse(extractedfdata['expiryDate']);
    if(expiryDate.isBefore(DateTime.now()))
      {
        return false;
      }
    _token=extractedfdata['token'];
    userId=extractedfdata['userId'];
    _expiryDate=expiryDate;
    notifyListeners();
    autologout();
    return true;
  }
  Future<void> logout() async{
    _token=null;
    userId=null;
    _expiryDate=null;

    if(_authtimer!=null){
      _authtimer.cancel();
      _authtimer=null;
    }
    notifyListeners();
    final prefs=await SharedPreferences.getInstance();
    prefs.clear();
  }
  void autologout(){
    if(_authtimer!=null)
    {
      _authtimer.cancel();
    }
    final expirytime=_expiryDate.difference(DateTime.now()).inSeconds;
    _authtimer=Timer(Duration(seconds: expirytime),logout);
  }
}