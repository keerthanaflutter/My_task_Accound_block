import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'account_api.dart';
import 'theme/app_theme.dart';
import 'widgets/password_field.dart';

void main() => runApp(DeleteAccountApp(client: http.Client()));

class DeleteAccountApp extends StatelessWidget {
  final http.Client client;

  const DeleteAccountApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delete Account — My Task',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: DeleteAccountPage(client: client),
    );
  }
}

// ── DeleteAccountPage ──────────────────────────────────────────────────────

class DeleteAccountPage extends StatefulWidget {
  final http.Client client;

  const DeleteAccountPage({super.key, required this.client});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _confirmed = false;
  bool _busy = false;
  bool _deleted = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final email = _email.text.trim();
    if (email.isEmpty || _password.text.isEmpty) {
      return setState(() => _error = 'Enter your email and password.');
    }
    if (!_confirmed) return setState(() => _error = 'Tick the box to confirm.');

    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await deleteAccount(widget.client, email, _password.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
      _deleted = error == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header(),
                  const SizedBox(height: 32),
                  const _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _List(title: 'What is deleted', kept: false, items: [
                          'Your name, email, phone number and password',
                          'Tasks you created',
                          'Direct messages, notifications and accepted invites',
                        ]),
                        SizedBox(height: 20),
                        _List(title: 'What is kept', kept: true, items: [
                          'Tasks others assigned to you stay with their creator; you are removed from them',
                          'Your messages on others\' tasks stay, shown as "Deleted user"',
                        ]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
                    child: Text(
                      'Deletion is immediate and cannot be undone. You can sign up again later '
                      'with the same email. Company accounts are managed by your organisation — '
                      'ask your administrator to delete them.',
                      style: TextStyle(color: c.textSecondary, fontSize: 13, height: 1.5),
                    ),
                  ),
                  _deleted ? const _DoneCard() : _form(c),
                  const SizedBox(height: 24),
                  Text('My Task',
                      textAlign: TextAlign.center, style: TextStyle(color: c.textSecondary, fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(AppColors c) {
    return _Card(
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Confirm with your login', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const SizedBox(height: 12),
            PasswordField(
              controller: _password,
              hintText: 'Password',
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _busy ? null : _delete(),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _confirmed,
              onChanged: (v) => setState(() => _confirmed = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: c.error,
              title: Text('I understand this permanently deletes my account and my tasks.',
                  style: TextStyle(color: c.textPrimary, fontSize: 14)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _busy ? null : _delete,
              style: ElevatedButton.styleFrom(backgroundColor: c.error, elevation: 0),
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Delete my account', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: c.error, fontSize: 14)),
            ],
          ],
        ),
      ),
    );
  }
}

// ── pieces ─────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        // ponytail: placeholder logo, swap for the real app icon once it exists.
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: c.primary,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 34),
        ),
        const SizedBox(height: 20),
        Text('Delete your account',
            style: TextStyle(color: c.textPrimary, fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(children: [
            const TextSpan(text: 'You can also do this in the app: '),
            TextSpan(
              text: 'Profile → Delete account',
              style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w500),
            ),
          ]),
          textAlign: TextAlign.center,
          style: TextStyle(color: c.textSecondary, fontSize: 14),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
        side: BorderSide(color: c.divider),
      ),
      child: Padding(padding: const EdgeInsets.all(24), child: child),
    );
  }
}

class _List extends StatelessWidget {
  final String title;
  final bool kept;
  final List<String> items;

  const _List({required this.title, required this.kept, required this.items});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(kept ? Icons.check_rounded : Icons.close_rounded,
                      size: 16, color: kept ? c.success : c.error),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(item, style: TextStyle(color: c.textSecondary, fontSize: 14, height: 1.45))),
              ],
            ),
          ),
      ],
    );
  }
}

class _DoneCard extends StatelessWidget {
  const _DoneCard();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _Card(
      child: Column(
        children: [
          Icon(Icons.check_circle_rounded, size: 44, color: c.success),
          const SizedBox(height: 12),
          Text('Your account has been deleted', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'You have been signed out everywhere. Thank you for using My Task.',
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
