import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserFormScreen extends ConsumerStatefulWidget {
  final UserModel? user;

  const UserFormScreen({super.key, this.user});

  @override
  ConsumerState<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends ConsumerState<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
    _addressController =
        TextEditingController(text: widget.user?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveUser() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (widget.user != null) {
      final updatedUser = widget.user!.copyWith(
        name: name,
        email: email,
        phone: phone,
        address: address,
      );
      ref.read(userListProvider.notifier).updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully')),
      );
    } else {
      final newUser = UserModel(
        id: const Uuid().v4(),
        name: name,
        email: email,
        phone: phone,
        address: address,
      );
      ref.read(userListProvider.notifier).addUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully')),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit User' : 'Add User'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Name',
                hintText: 'Enter name',
                prefixIcon: Icons.person,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                hintText: 'Enter email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter email';
                  }
                  if (!val.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hintText: 'Enter phone number',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _addressController,
                label: 'Address',
                hintText: 'Enter address',
                prefixIcon: Icons.home,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: isEditing ? 'Update' : 'Save',
                icon: Icons.check,
                onPressed: _saveUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
