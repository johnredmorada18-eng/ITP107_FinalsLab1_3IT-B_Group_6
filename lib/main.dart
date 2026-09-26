import 'package:flutter/material.dart';

void main() => runApp(const PanelVerseApp());

// Shared colors and the bundled manga/manhwa background.
const ink = Color(0xFF0C0E13);
const panel = Color(0xFF161920);
const coral = Color(0xFFFF6B60);
const paper = Color(0xFFF9F5EF);
const muted = Color(0xFFBBC0CA);
const mangaBackground = 'assets/images/manga_background.png';

class AppRoutes {
  static const login = '/';
  static const signUp = '/signup';
  static const home = '/home';
}

// Only the display name is passed to Home. Passwords are never passed or saved.
class HomeArguments {
  final String name;
  const HomeArguments(this.name);
}

class PanelVerseApp extends StatelessWidget {
  const PanelVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PanelVerse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ink,
        colorScheme: ColorScheme.fromSeed(
          seedColor: coral,
          brightness: Brightness.dark,
        ).copyWith(primary: coral, onPrimary: ink, surface: panel),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF101218),
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          labelStyle: const TextStyle(color: muted),
          prefixIconColor: muted,
          suffixIconColor: muted,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3A3E49)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: coral, width: 1.5),
          ),
          errorMaxLines: 3,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: coral,
            foregroundColor: ink,
            minimumSize: const Size.fromHeight(54),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: coral),
        ),
      ),
      // The laboratory requires all three screens to use named routes.
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.signUp: (_) => const SignUpScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
      },
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN 1: LOGIN
// This is a UI/navigation lab: any nonempty username and a password of at least
// six characters are accepted. There is no authentication server or database.
// ---------------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final username = _username.text.trim();
    final name = username.contains('@') ? username.split('@').first : username;

    // Remove authentication screens so Back cannot reveal the old form.
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
      arguments: HomeArguments(name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MangaPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandHeader(chapter: '01 / LOGIN'),
          const SizedBox(height: 64),
          const Eyebrow('YOUR NEXT CHAPTER'),
          const SizedBox(height: 12),
          const HeroTitle('Welcome\nback, reader.'),
          const SizedBox(height: 12),
          const Text(
            'Step into the stories you love.',
            style: TextStyle(color: paper, fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 28),
          InkPanel(
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MangaField(
                      fieldKey: const Key('loginUsername'),
                      controller: _username,
                      label: 'Email or username',
                      hint: 'reader@example.com',
                      icon: Icons.person_outline_rounded,
                      autofillHints: const [AutofillHints.username],
                      validator: (value) {
                        final text = (value ?? '').trim();
                        if (text.isEmpty) return 'Enter your email or username.';
                        if (text.startsWith('@')) return 'Enter a valid username.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    MangaField(
                      fieldKey: const Key('loginPassword'),
                      controller: _password,
                      label: 'Password',
                      hint: 'At least 6 characters',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      autofillHints: const [AutofillHints.password],
                      validator: validatePassword,
                      onSubmitted: _login,
                    ),
                    const SizedBox(height: 24),
                    ActionButton(
                      buttonKey: const Key('loginButton'),
                      label: 'Log in',
                      onPressed: _login,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'New to the story?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted),
                    ),
                    TextButton(
                      key: const Key('openSignUp'),
                      // pushNamed keeps Login underneath, allowing pop on Back.
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.signUp,
                      ),
                      child: const Text('Create an account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const PageFooter(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN 2: SIGN UP
// ---------------------------------------------------------------------------
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _signUp() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    // Pass the actual full name through the named route's arguments.
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
      arguments: HomeArguments(_name.text.trim()),
    );
  }

  void _backToLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // Also works if Sign Up is opened directly as a named route.
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MangaPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandHeader(chapter: '02 / SIGN UP'),
          const SizedBox(height: 32),
          const Eyebrow('A NEW STORY BEGINS'),
          const SizedBox(height: 12),
          const HeroTitle('Join the\nPanelVerse.'),
          const SizedBox(height: 12),
          const Text(
            'Every great adventure starts with a name.',
            style: TextStyle(color: paper, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),
          InkPanel(
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MangaField(
                      fieldKey: const Key('signUpName'),
                      controller: _name,
                      label: 'Full name',
                      hint: 'What should we call you?',
                      icon: Icons.badge_outlined,
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.name],
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Enter your full name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    MangaField(
                      fieldKey: const Key('signUpEmail'),
                      controller: _email,
                      label: 'Email',
                      hint: 'reader@example.com',
                      icon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) {
                        final text = (value ?? '').trim();
                        if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                            .hasMatch(text)) {
                          return 'Enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    MangaField(
                      fieldKey: const Key('signUpPassword'),
                      controller: _password,
                      label: 'Password',
                      hint: 'At least 6 characters',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 18),
                    MangaField(
                      fieldKey: const Key('signUpConfirm'),
                      controller: _confirmPassword,
                      label: 'Confirm password',
                      hint: 'Enter your password again',
                      icon: Icons.verified_user_outlined,
                      isPassword: true,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm your password.';
                        }
                        if (value != _password.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                      onSubmitted: _signUp,
                    ),
                    const SizedBox(height: 24),
                    ActionButton(
                      buttonKey: const Key('signUpButton'),
                      label: 'Sign up',
                      onPressed: _signUp,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      key: const Key('backToLogin'),
                      onPressed: _backToLogin,
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('Back to login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const PageFooter(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN 3: HOME
// ---------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final name = arguments is HomeArguments && arguments.name.trim().isNotEmpty
        ? arguments.name
        : 'Reader';

    return MangaPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandHeader(chapter: '03 / HOME'),
          const SizedBox(height: 48),
          const Eyebrow('THE READER\'S LOUNGE'),
          const SizedBox(height: 12),
          Text(
            'Welcome,\n$name.',
            key: const Key('welcomeName'),
            style: const TextStyle(
              color: paper,
              fontSize: 38,
              fontWeight: FontWeight.w900,
              height: 1.12,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'A whole universe of stories. A place to call yours.',
            style: TextStyle(color: paper, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 28),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: MangaArtwork(alignment: Alignment.topCenter),
                ),
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x000C0E13), Color(0xF20C0E13)],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Eyebrow('MANGA MEETS MANHWA'),
                      const SizedBox(height: 180),
                      const Text(
                        'A world in\nevery panel.',
                        style: TextStyle(
                          color: paper,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.08,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          GenreTag('ACTION'),
                          GenreTag('FANTASY'),
                          GenreTag('ADVENTURE'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          InkPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.auto_stories_rounded, color: coral, size: 30),
                const SizedBox(height: 12),
                const Text(
                  'You\'re part of the story.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: paper,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Until the next chapter, reader.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, height: 1.5),
                ),
                const SizedBox(height: 20),
                ActionButton(
                  buttonKey: const Key('logoutButton'),
                  label: 'Log out',
                  icon: Icons.logout_rounded,
                  onPressed: () {
                    // Clear Home as well, so Back cannot reopen it after logout.
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
          const PageFooter(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// REUSABLE UI: one style system for all three screens.
// ---------------------------------------------------------------------------
String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) return 'Enter a password.';
  if (value.length < 6) return 'Use at least 6 characters.';
  return null;
}

class MangaPage extends StatelessWidget {
  final Widget child;
  const MangaPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(child: MangaArtwork()),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x700C0E13),
                    Color(0xB30C0E13),
                    Color(0xF70C0E13),
                  ],
                  stops: [0, 0.4, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: (constraints.maxHeight - 48)
                          .clamp(0.0, double.infinity)
                          .toDouble(),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 460),
                        child: SizedBox(width: double.infinity, child: child),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MangaArtwork extends StatelessWidget {
  final Alignment alignment;
  const MangaArtwork({super.key, this.alignment = Alignment.topCenter});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      mangaBackground,
      fit: BoxFit.cover,
      alignment: alignment,
      excludeFromSemantics: true,
      // A readable fallback if the asset is accidentally removed.
      errorBuilder: (context, error, stackTrace) => const ColoredBox(color: ink),
    );
  }
}

class BrandHeader extends StatelessWidget {
  final String chapter;
  const BrandHeader({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.auto_stories_rounded, color: coral, size: 24),
            SizedBox(width: 10),
            Text(
              'PANELVERSE',
              style: TextStyle(
                color: paper,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
        Text(
          chapter,
          style: const TextStyle(
            color: paper,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
      ],
    );
  }
}

class HeroTitle extends StatelessWidget {
  final String text;
  const HeroTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: paper,
          fontSize: 44,
          fontWeight: FontWeight.w900,
          height: 1.05,
          letterSpacing: -1.5,
        ),
      );
}

class Eyebrow extends StatelessWidget {
  final String text;
  const Eyebrow(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: coral,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
          height: 1.5,
        ),
      );
}

class InkPanel extends StatelessWidget {
  final Widget child;
  const InkPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xF2161920),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3A3E49)),
          boxShadow: const [
            BoxShadow(color: Color(0x55000000), blurRadius: 28, offset: Offset(0, 12)),
          ],
        ),
        child: child,
      );
}

class MangaField extends StatefulWidget {
  final Key? fieldKey;
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final VoidCallback? onSubmitted;

  const MangaField({
    super.key,
    this.fieldKey,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.onSubmitted,
  });

  @override
  State<MangaField> createState() => _MangaFieldState();
}

class _MangaFieldState extends State<MangaField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword && _hidden,
      autocorrect: false,
      enableSuggestions: !widget.isPassword,
      keyboardType: widget.isPassword
          ? TextInputType.visiblePassword
          : widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      autofillHints: widget.autofillHints,
      textInputAction: widget.onSubmitted == null
          ? TextInputAction.next
          : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (widget.onSubmitted != null) {
          widget.onSubmitted!();
        } else {
          FocusScope.of(context).nextFocus();
        }
      },
      style: const TextStyle(color: paper, fontSize: 15),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(widget.icon, size: 21),
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _hidden ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => _hidden = !_hidden),
                icon: Icon(
                  _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 21,
                ),
              )
            : null,
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final Key? buttonKey;
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const ActionButton({
    super.key,
    this.buttonKey,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
  });

  @override
  Widget build(BuildContext context) => FilledButton(
        key: buttonKey,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Text(label, textAlign: TextAlign.center)),
            const SizedBox(width: 12),
            Icon(icon, size: 20),
          ],
        ),
      );
}

class GenreTag extends StatelessWidget {
  final String label;
  const GenreTag(this.label, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xE6161920),
          border: Border.all(color: const Color(0xFF686A71)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: paper,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      );
}

class PageFooter extends StatelessWidget {
  const PageFooter({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.only(top: 24, bottom: 8),
        child: Center(
          child: Text(
            'MANGA  /  MANHWA  /  YOUR UNIVERSE',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 9, letterSpacing: 1.8, height: 1.6),
          ),
        ),
      );
}
