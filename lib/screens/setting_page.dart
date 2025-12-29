import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'ecg_data_service.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xalute/screens/api_client.dart';
import 'package:kpostal/kpostal.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    String formatted = '';
    if (digits.length <= 3) {
      formatted = digits;
    } else if (digits.length <= 7) {
      formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
    } else if (digits.length <= 11) {
      formatted =
      '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
    } else {
      // 11자리 초과하면 잘라 버림
      digits = digits.substring(0, 11);
      formatted =
      '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}


//name, birthDate, phone, address
class _SettingPageState extends State<SettingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneNumberController  = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailedAddressController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  File? _profileImage;
  bool _hasChanges = false;
  bool _showRoadAddressField = false;
  String postCode = '';
  String roadAddress = '';
  String jibunAddress = '';
  String detailedAddress = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _nameFocus.addListener(() {
      if (_nameFocus.hasFocus && _nameController.text.isEmpty) {
        _nameController.clear();
      }
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username') ?? '';
    final birthday = prefs.getString('birthDate') ?? '';
    final imagePath = prefs.getString('profileImagePath');
    final phoneNumber = prefs.getString('phoneNumber') ?? '';
    final address = prefs.getString('address') ?? '';

    // Firebase User 정보
    final user = FirebaseAuth.instance.currentUser;
    String firebaseName = '';
    String firebaseEmail = '';
    if (user != null) {
      for (final providerProfile in user.providerData) {
        if (providerProfile.providerId == 'google.com') {
          firebaseName = providerProfile.displayName ?? '';
          firebaseEmail = providerProfile.email ?? '';
        }
      }
    }

    setState(() {
      _nameController.text =  name.isNotEmpty ? name : firebaseName;
      _birthdayController.text = birthday;
      _phoneNumberController.text = phoneNumber;
      _addressController.text = roadAddress;
      _detailedAddressController.text = detailedAddress;
      if (imagePath != null) {
        _profileImage = File(imagePath);
      }
    });

    final ecgService = Provider.of<EcgDataService>(context, listen: false);
    ecgService.setUserName(_nameController.text);
    ecgService.setBirthDate(_birthdayController.text);
    ecgService.setPhoneNumber(_phoneNumberController.text);
    ecgService.setAddress(_addressController.text);
  }

  Future<void> _saveUserData() async {
    final api = ApiClient();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', _nameController.text);
    await prefs.setString('birthDate', _birthdayController.text);
    await prefs.setString('phoneNumber', _phoneNumberController.text);
    await prefs.setString('address', _addressController.text);

    final ecgService = Provider.of<EcgDataService>(context, listen: false);
    ecgService.setUserName(_nameController.text);
    ecgService.setBirthDate(_birthdayController.text);
    ecgService.setPhoneNumber(_phoneNumberController.text);
    ecgService.setAddress(_addressController.text);

    if (_profileImage != null) {
      await prefs.setString('profileImagePath', _profileImage!.path);
      ecgService.setProfileImagePath(_profileImage!.path);
    } else {
      await prefs.remove('profileImagePath');
      ecgService.setProfileImagePath(null);
    }

    setState(() => _hasChanges = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("저장되었습니다.")),
    );

    final response = await api.post(
      "auth/login",
      body: {"email": "test@example.com", "password": "1234"},
    );

    print(response.body);
  }



  Future<void> _selectBirthday() async {
    DateTime initialDate = DateTime.tryParse(_birthdayController.text.replaceAll('.', '-')) ??
        DateTime(2000, 1, 1);

    DateTime selectedDate = initialDate;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: const Text('취소', style: TextStyle(color: Colors.grey)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('확인', style: TextStyle(color: Colors.redAccent)),
                      onPressed: () {
                        setState(() {
                          _birthdayController.text = DateFormat('yyyy.MM.dd').format(selectedDate);
                          _hasChanges = true;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('프로필 사진 변경'),
          children: [
            SimpleDialogOption(
              child: const Text('카메라로 촬영'),
              onPressed: () async {
                Navigator.pop(context, true);
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _profileImage = File(pickedFile.path);
                    _hasChanges = true;
                  });
                }
              },
            ),
            SimpleDialogOption(
              child: const Text('갤러리에서 선택'),
              onPressed: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _profileImage = File(pickedFile.path);
                    _hasChanges = true;
                  });
                }
              },
            ),
            SimpleDialogOption(
              child: const Text('기본 이미지로 변경'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _profileImage = null;
                  _hasChanges = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFE),
      appBar: AppBar(
        title: const Text("Setting"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/icon/profile.png') as ImageProvider,
                  ),
                  const SizedBox(height: 8),
                  const Text('바꾸기', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("이름", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(
                hintText: "이름을 입력하세요",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (_) => setState(() => _hasChanges = true),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("전화번호", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                PhoneNumberFormatter(),     // ← 자동 포맷 적용
              ],
              decoration: InputDecoration(
                hintText: "전화번호를 입력하세요",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (_) => setState(() => _hasChanges = true),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => KpostalView(
                      useLocalServer: true,
                      localPort: 1024,
                      callback: (Kpostal result) {
                        setState(() {
                          postCode = result.postCode;
                          roadAddress = result.address;
                          jibunAddress = result.jibunAddress;

                          // 🔥 주소 검색 결과 → address controller
                          _addressController.text = roadAddress;

                          // 🔥 상세주소가 이미 있으면 합치기
                          if (_detailedAddressController.text.isNotEmpty) {
                            _addressController.text =
                            "$roadAddress ${_detailedAddressController.text}";
                          }

                          _hasChanges = true;
                        });
                      },
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "도로명 주소",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFEFEFEF)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            roadAddress.isNotEmpty
                                ? roadAddress
                                : "도로명 주소를 검색하세요",
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: roadAddress.isNotEmpty
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        const Icon(Icons.search, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "상세주소",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _detailedAddressController,
                decoration: InputDecoration(
                  hintText: "상세주소를 입력하세요", // 🔥 처음에 보이는 회색 텍스트
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFEFEFEF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFEFEFEF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    detailedAddress = value;
                    _addressController.text =
                    roadAddress.isNotEmpty
                        ? "$roadAddress $detailedAddress"
                        : detailedAddress;
                    _hasChanges = true;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("생년월일", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectBirthday,
              child: AbsorbPointer(
                child: TextField(
                  controller: _birthdayController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: const Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _hasChanges ? _saveUserData : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("저장하기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEFEFEF)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEFEFEF)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTextField(String label, TextEditingController controller, FocusNode? focusNode, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEFEFEF)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEFEFEF)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) => setState(() => _hasChanges = true),
        ),
      ],
    );
  }
}