import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.auth});

  final AuthService auth;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _register = false;
  bool _busy = false;
  bool _hidePassword = true;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _username, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = _register
        ? await widget.auth.register(
            name: _name.text,
            username: _username.text,
            email: _email.text,
            password: _password.text,
          )
        : await widget.auth.login(_username.text, _password.text);
    if (mounted) {
      setState(() {
        _busy = false;
        _error = error;
      });
    }
  }

  Widget _providerIcon(SocialProvider p) {
    switch (p) {
      case SocialProvider.google:
        return const Text(
          'G',
          style: TextStyle(
            color: Color(0xFFDB4437),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        );
      case SocialProvider.facebook:
        return const Icon(Icons.facebook, color: Color(0xFF1877F2));
      case SocialProvider.apple:
        return const Icon(Icons.apple);
    }
  }

  // Demo flow: replace with the provider's real OAuth SDK once credentials exist.
  Future<void> _social(SocialProvider p) async {
    final r = await showDialog<(String, String)>(
      context: context,
      builder: (_) => _SocialDialog(provider: p),
    );
    if (r == null) return;
    await widget.auth.socialSignIn(p, name: r.$1, email: r.$2);
  }

  void _toggle() => setState(() {
    _register = !_register;
    _error = null;
    _form.currentState?.reset();
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.school,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'JAMB CBT Practice',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _register
                              ? 'Create your student account'
                              : 'Log in to continue practising',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        for (final p in SocialProvider.values) ...[
                          OutlinedButton.icon(
                            onPressed: _busy ? null : () => _social(p),
                            icon: _providerIcon(p),
                            label: Text('Continue with ${p.label}'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('OR'),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_register) ...[
                          TextFormField(
                            controller: _name,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Full name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => (v ?? '').trim().length < 2
                                ? 'Enter your full name'
                                : null,
                          ),
                          const SizedBox(height: 12),
                        ],
                        TextFormField(
                          controller: _username,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            final s = (v ?? '').trim();
                            if (!_register) {
                              return s.isEmpty ? 'Required' : null;
                            }
                            return RegExp(r'^[A-Za-z0-9_]{3,20}$').hasMatch(s)
                                ? null
                                : '3-20 letters, numbers or underscore';
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_register) ...[
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email (optional)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) {
                              final s = (v ?? '').trim();
                              return s.isEmpty ||
                                      RegExp(r'^\S+@\S+\.\S+$').hasMatch(s)
                                  ? null
                                  : 'Enter a valid email';
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                        TextFormField(
                          controller: _password,
                          obscureText: _hidePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () => setState(
                                () => _hidePassword = !_hidePassword,
                              ),
                            ),
                          ),
                          validator: (v) {
                            final s = v ?? '';
                            if (!_register) {
                              return s.isEmpty ? 'Required' : null;
                            }
                            return s.length < 6
                                ? 'At least 6 characters'
                                : null;
                          },
                        ),
                        if (_register) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirm,
                            obscureText: _hidePassword,
                            decoration: const InputDecoration(
                              labelText: 'Confirm password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v != _password.text
                                ? 'Passwords do not match'
                                : null,
                          ),
                        ],
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              _error!,
                              style: TextStyle(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _busy ? null : _submit,
                          child: Text(_register ? 'Register' : 'Log in'),
                        ),
                        TextButton(
                          onPressed: _toggle,
                          child: Text(
                            _register
                                ? 'Already registered? Log in'
                                : 'New here? Create an account',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialDialog extends StatefulWidget {
  const _SocialDialog({required this.provider});

  final SocialProvider provider;

  @override
  State<_SocialDialog> createState() => _SocialDialogState();
}

class _SocialDialogState extends State<_SocialDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.provider.label;
    return AlertDialog(
      title: Text('Continue with $label'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (v) =>
                  (v ?? '').trim().length < 2 ? 'Enter your name' : null,
            ),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: '$label email'),
              validator: (v) => RegExp(r'^\S+@\S+\.\S+$').hasMatch(v ?? '')
                  ? null
                  : 'Enter a valid email',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, (_name.text, _email.text));
            }
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
