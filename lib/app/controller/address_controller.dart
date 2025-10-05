import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:odda/app/model/add_address_data.dart';
import 'package:odda/app/model/normal_response.dart';
import 'package:permission_handler/permission_handler.dart';

import '../repository/address_repository.dart';

class AddressController extends GetxController{
  final addressSelectedPos = 0.obs;
  late TextEditingController pinController;
  late TextEditingController numberController;
  late TextEditingController informationController;
  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController addressTypeController;
  var lat = '';
  var lng = '';
  final isLoading = false.obs;
  final isFetchingAddress = false.obs;
  late AddressRepository _addressRepository;
  final addressList = <AddAddressDatum>[].obs;


  AddressController(){
    pinController = TextEditingController();
    numberController = TextEditingController();
    informationController = TextEditingController();
    stateController = TextEditingController();
    cityController = TextEditingController();
    addressTypeController = TextEditingController();
    _addressRepository = AddressRepository();
  }

  @override
  void onInit(){
    super.onInit();
    getAddressList();
  }


  void getCurrentAddress() async {
    managePermissions();
  }

  void managePermissions() async{
    if (await Permission.location.request().isGranted) {
      isFetchingAddress.value = true;
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];
      cityController.text = '${placemark.subAdministrativeArea}, ${placemark.administrativeArea}';
      // stateController.text = placemark.administrativeArea.toString();
      pinController.text = placemark.postalCode.toString();
      lat = position.latitude.toString();
      lng = position.longitude.toString();
      isFetchingAddress.value = false;
    } else if (await Permission.location.request().isPermanentlyDenied && GetPlatform.isAndroid) {
      openAppSettings();
    } else {
      Get.snackbar('Permissions Required', 'Please allow location permissions.');
    }
  }

  void addAddress(BuildContext context) async {
    try{
      isLoading.value = true;
      AddAddressData addAddressData = await _addressRepository.addAddress(informationController.text, pinController.text, addressTypeController.text.toString(), numberController.text, cityController.text, stateController.text, lat, lng);
      addressList.assignAll(addAddressData.data);
      informationController.clear();
      pinController.clear();
      cityController.clear();
      stateController.clear();
      numberController.clear();
      informationController.clear();
      addressTypeController.clear();
      setDefaultAddress(addAddressData.data[0].id.toString(), true);
      isLoading.value = false;
    } catch(e){
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print('Upper ===  ${e.response!.data}');
        }
      } else {
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void getAddressList() async {
    try{
      isLoading.value = true;
      AddAddressData addAddressData = await _addressRepository.getAddressList();
      addressList.assignAll(addAddressData.data);
      for(int i = 0;i<addressList.length;i++){
        if(addressList[i].isDefault == 1){
          addressSelectedPos.value = i;
        }
      }
      isLoading.value = false;
    } catch(e){
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print('Upper ===  ${e.response!.data}');
        }
      } else {
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void setDefaultAddress(String addressId,bool isFromAddAddress) async {
    try{
      NormalResponse normalResponse = await _addressRepository.setDefaultAddress(addressId);
      if (kDebugMode) {
        print('Default address Selected');
      }
      if(isFromAddAddress) {
        isLoading.value = false;
        addressSelectedPos.value = 0;
        Get.back();
      }
    } catch(e){
      if(isFromAddAddress) {
        isLoading.value = false;
      }
      if (e is DioException) {
        if(isFromAddAddress) {
          isLoading.value = false;
        }
        if (kDebugMode) {
          print('Upper ===  ${e.response!.data}');
        }
      } else {
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    }
  }


  void deleteAddress(String addressId,int index) async {
    try {
      isLoading.value = true;
      NormalResponse normalResponse = await _addressRepository.deleteAddress(
          addressId);
      // getCurrentAddress();
      addressList.removeAt(index);
      addressList.refresh();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print('Upper ===  ${e.response!.data}');
        }
      } else {
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    }
  }
}