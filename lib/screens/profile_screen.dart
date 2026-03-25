import 'package:book_store_mobile_app/core/routes.dart';
import 'package:book_store_mobile_app/models/user.dart';
import 'package:book_store_mobile_app/theme/app_theme.dart';
import 'package:book_store_mobile_app/widgets/main_speed_dial.dart';
import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  bool _isEditing = false;
  bool _showPasswordFields = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthDateController = TextEditingController();

  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  String _username = "";
  String _avatarUrl = "";

  final List<String> _genderOptions = ["Male", "Female", "Other"];
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _fetchUserData() async {
    final result = await _profileService.getProfile();
    if (result['success']) {
      final user = UserModel.fromJson(result['data']);
      setState(() {
        _username = user.username;
        _nameController.text = user.fullName;
        _phoneController.text = user.phoneNumber ?? "";
        _addressController.text = user.address ?? "";
        _avatarUrl = user.avatarUrl ?? "";

        if (user.gender != null && _genderOptions.contains(user.gender)) {
          _selectedGender = user.gender;
        }

        if (user.birthDate != null) {
          _birthDateController.text = _formatDate(user.birthDate!);
        }

        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to sign out?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("CANCEL"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "LOGOUT",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      await _authService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.splash,
          (route) => false,
        );
      }
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    Map<String, dynamic> updateData = {
      "fullName": _nameController.text,
      "phoneNumber": _phoneController.text,
      "address": _addressController.text,
      "gender": _selectedGender,
      "birthDate": _birthDateController.text,
      "avatarUrl": _avatarUrl,
    };

    if (_showPasswordFields) {
      updateData.addAll({
        "oldPassword": _oldPassController.text,
        "newPassword": _newPassController.text,
        "confirmPassword": _confirmPassController.text,
      });
    }

    final result = await _profileService.updateProfile(updateData);

    if (result['success']) {
      _showMsg("Profile updated successfully!");
      setState(() {
        _isEditing = false;
        _showPasswordFields = false;
        _clearPassFields();
      });
      _fetchUserData();
    } else {
      _showMsg(result['message'], isError: true);
      setState(() => _isLoading = false);
    }
  }

  void _clearPassFields() {
    _oldPassController.clear();
    _newPassController.clear();
    _confirmPassController.clear();
  }

  void _showMsg(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : AppColors.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "User Profile",
          style: theme.textTheme.displayLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: colorScheme.secondary,
                    backgroundImage: NetworkImage(
                      _avatarUrl.isNotEmpty
                          ? _avatarUrl
                          : "https://ui-avatars.com/api/?name=$_username&background=random&color=fff",
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: AppColors.accent,
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _avatarUrl =
                                  "https://picsum.photos/200/200?random=${DateTime.now().millisecondsSinceEpoch}";
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- INPUT FIELDS ---
            _buildField(
              "Username",
              TextEditingController(text: _username),
              Icons.alternate_email,
              enabled: false,
            ),
            _buildField(
              "Full Name",
              _nameController,
              Icons.person,
              enabled: _isEditing,
            ),
            _buildField(
              "Phone Number",
              _phoneController,
              Icons.phone,
              enabled: _isEditing,
            ),
            _buildField(
              "Address",
              _addressController,
              Icons.map,
              enabled: _isEditing,
            ),

            // --- GENDER DROPDOWN ---
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                style: theme.textTheme.bodyLarge,
                items: _genderOptions
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: _isEditing
                    ? (val) => setState(() => _selectedGender = val)
                    : null,
                decoration: InputDecoration(
                  labelText: "Gender",
                  prefixIcon: const Icon(Icons.wc),
                  border: const OutlineInputBorder(),
                  filled: !_isEditing,
                  fillColor: !_isEditing
                      ? colorScheme.secondary
                      : Colors.transparent,
                ),
              ),
            ),

            // --- BIRTH DATE ---
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: _birthDateController,
                readOnly: true,
                style: theme.textTheme.bodyLarge,
                onTap: _isEditing ? _selectDate : null,
                decoration: InputDecoration(
                  labelText: "Birth Date",
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                  filled: !_isEditing,
                  fillColor: !_isEditing
                      ? colorScheme.secondary
                      : Colors.transparent,
                ),
              ),
            ),

            // --- PASSWORD TOGGLE ---
            if (!_showPasswordFields)
              TextButton.icon(
                onPressed: () => setState(() => _showPasswordFields = true),
                icon: const Icon(Icons.lock_reset),
                label: const Text("Change Password"),
              )
            else ...[
              const Divider(height: 30),
              _buildField(
                "Old Password",
                _oldPassController,
                Icons.lock_outline,
                isPass: true,
              ),
              _buildField(
                "New Password",
                _newPassController,
                Icons.lock_open,
                isPass: true,
              ),
              _buildField(
                "Confirm Password",
                _confirmPassController,
                Icons.check_circle_outline,
                isPass: true,
              ),
              TextButton(
                onPressed: () => setState(() => _showPasswordFields = false),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // --- SAVE/EDIT BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // Nếu đang edit thì dùng màu Accent (Emerald), nếu không dùng màu Primary (Navy)
                  backgroundColor: (_isEditing || _showPasswordFields)
                      ? AppColors.accent
                      : colorScheme.primary,
                ),
                onPressed: () {
                  if (_isEditing || _showPasswordFields) {
                    _saveChanges();
                  } else {
                    setState(() => _isEditing = true);
                  }
                },
                child: Text(
                  _isEditing || _showPasswordFields
                      ? "SAVE CHANGES"
                      : "EDIT PROFILE",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --- LOGOUT BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _handleLogout,
                icon: Icon(Icons.logout, color: colorScheme.error),
                label: Text(
                  "LOGOUT",
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: const MainSpeedDial(),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDateController.text = _formatDate(picked));
    }
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    IconData icon, {
    bool enabled = true,
    bool isPass = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        enabled: enabled || isPass,
        obscureText: isPass,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          filled: !enabled && !isPass,
          fillColor: !enabled && !isPass
              ? theme.colorScheme.secondary
              : Colors.transparent,
        ),
      ),
    );
  }
}
