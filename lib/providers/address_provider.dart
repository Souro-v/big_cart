import 'package:flutter/material.dart';

class AddressModel {
  final String name;
  final String address;
  final String city;
  final String zip;
  final String country;
  final String phone;
  bool isDefault;

  AddressModel({
    required this.name,
    required this.address,
    required this.city,
    required this.zip,
    required this.country,
    required this.phone,
    this.isDefault = false,
  });

  String get fullAddress => '$address, $city, $zip, $country';
}

class AddressProvider extends ChangeNotifier {
  final List<AddressModel> _addresses = [];
  AddressModel? _selectedAddress;

  List<AddressModel> get addresses => _addresses;
  AddressModel? get selectedAddress => _selectedAddress;

  void addAddress(AddressModel address) {
    if (address.isDefault) {
      for (var a in _addresses) {
        a.isDefault = false;
      }
    }
    _addresses.add(address);
    if (address.isDefault || _addresses.length == 1) {
      _selectedAddress = address;
    }
    notifyListeners();
  }

  void selectAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void setDefault(AddressModel address) {
    for (var a in _addresses) {
      a.isDefault = false;
    }
    address.isDefault = true;
    _selectedAddress = address;
    notifyListeners();
  }

  void removeAddress(AddressModel address) {
    _addresses.remove(address);
    if (_selectedAddress == address) {
      _selectedAddress = _addresses.isNotEmpty ? _addresses.first : null;
    }
    notifyListeners();
  }
}