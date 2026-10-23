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
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 56),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header(),
                  const SizedBox(height: 28),
                  const _InfoCard(
                    title: 'What is deleted',
                    kept: false,
                    items: [
                      'Your name, email, phone number and password',
                      'Tasks you created',
                      'Direct messages, notifications and accepted invites',
                    ],
                  ),
                  const _InfoCard(
                    title: 'What is kept',
                    kept: true,
                    items: [
                      'Tasks others assigned to you stay with their creator; you are removed from them',
                      'Your messages on others\' tasks stay, shown as "Deleted user"',
                    ],
                    note: 'Deletion is immediate and cannot be undone. You can sign up again later '
                        'with the same email. Company accounts are managed by your organisation — '
                        'ask your administrator to delete them.',
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
            Text('Sign in to confirm', style: Theme.of(context).textTheme.titleMedium),
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
              activeColor: c.primary,
              title: Text('I understand this permanently deletes my account and my tasks.',
                  style: TextStyle(color: c.textPrimary, fontSize: 14)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _busy ? null : _delete,
              style: ElevatedButton.styleFrom(backgroundColor: c.error),
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Delete my account', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: c.statusDelayed.background,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
                ),
                child: Text(_error!, style: TextStyle(color: c.statusDelayed.foreground, fontSize: 14)),
              ),
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
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: c.primary,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
        ),
        const SizedBox(height: 16),
        Text('Delete your account',
            style: TextStyle(color: c.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(children: [
            const TextSpan(text: 'You can also do this in the app: '),
            TextSpan(
              text: 'Profile → Delete account',
              style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w600),
            ),
          ]),
          textAlign: TextAlign.center,
          style: TextStyle(color: c.textSecondary),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final bool kept;
  final List<String> items;
  final String? note;

  const _InfoCard({required this.title, required this.kept, required this.items, this.note});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final badge = kept ? c.statusDone : c.statusDelayed;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: badge.background,
                    child: Icon(kept ? Icons.check : Icons.close, size: 12, color: badge.foreground),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item, style: TextStyle(color: c.textSecondary))),
                ],
              ),
            ),
          if (note != null) ...[
            Divider(height: 24, color: c.divider),
            Text(note!, style: TextStyle(color: c.textSecondary, fontSize: 13)),
          ],
        ],
      ),
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
          const SizedBox(height: 12),
          CircleAvatar(
            radius: 28,
            backgroundColor: c.statusDone.background,
            child: Icon(Icons.check_rounded, size: 30, color: c.statusDone.foreground),
          ),
          const SizedBox(height: 12),
          Text('Your account has been deleted', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'You have been signed out everywhere. Thank you for using My Task.',
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textSecondary),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
