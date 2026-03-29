import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ui/ui.dart';

import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _storage = FlutterSecureStorage();
  static const _keyEmail = 'saved_email';
  static const _keyPassword = 'saved_password';
  static const _keyRememberMe = 'remember_me';

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final rememberMe = await _storage.read(key: _keyRememberMe);
    if (rememberMe != 'true') return;
    final email = await _storage.read(key: _keyEmail);
    final password = await _storage.read(key: _keyPassword);
    if (!mounted) return;
    setState(() {
      _rememberMe = true;
      if (email != null) _emailController.text = email;
      if (password != null) _passwordController.text = password;
    });
  }

  Future<void> _saveOrClearCredentials() async {
    if (_rememberMe) {
      await _storage.write(key: _keyEmail, value: _emailController.text.trim());
      await _storage.write(key: _keyPassword, value: _passwordController.text);
      await _storage.write(key: _keyRememberMe, value: 'true');
    } else {
      await _storage.delete(key: _keyEmail);
      await _storage.delete(key: _keyPassword);
      await _storage.delete(key: _keyRememberMe);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _saveOrClearCredentials();
    context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).appColors;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colors.danger,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    gapH32,
                    Text(
                      l10n.appName,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.accent,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    gapH8,
                    Text(
                      l10n.signInToYourAccount,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.textMuted,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    gapH32,
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: InputDecoration(labelText: l10n.email),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return l10n.emailRequired;
                        if (!v.contains('@')) return l10n.emailInvalid;
                        return null;
                      },
                    ),
                    gapH16,
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return l10n.passwordRequired;
                        return null;
                      },
                    ),
                    gapH8,
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          activeColor: colors.accent,
                          onChanged: (value) =>
                              setState(() => _rememberMe = value ?? false),
                        ),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _rememberMe = !_rememberMe),
                          child: Text(
                            l10n.rememberMe,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    gapH24,
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          label: l10n.signIn,
                          isLoading: state is AuthLoading,
                          onPressed: _submit,
                        );
                      },
                    ),
                    gapH32,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
