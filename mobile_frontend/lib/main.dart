import 'package:flutter/material.dart';

// Theme colors
const Color kPrimaryColor = Color(0xFF1565C0);
const Color kSecondaryColor = Color(0xFF42A5F5);
const Color kAccentColor = Color(0xFFFFB300);

// UserType enum for role-based dashboard switching
enum UserType { user, provider }

void main() {
  runApp(const ECCSApp());
}

// PUBLIC_INTERFACE
class ECCSApp extends StatelessWidget {
  /// Root widget for the Electronic City Commuter Service (ECCS) mobile app.
  const ECCSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EC Commuter Service',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          primaryContainer: kPrimaryColor,
          secondaryContainer: kSecondaryColor,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          error: Colors.red,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          surfaceTintColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: kPrimaryColor,
          unselectedLabelColor: Colors.black54,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: kAccentColor, width: 2),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kAccentColor,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

// PUBLIC_INTERFACE
class AuthGate extends StatefulWidget {
  /// Handles login/signup toggle and navigation to user/provider dashboard.
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool isLogin = true;
  UserType? userType;

  @override
  Widget build(BuildContext context) {
    if (userType == null) {
      // Show initial login/signup screen
      return AuthScreen(
        isLogin: isLogin,
        onAuthCompleted: (UserType type) {
          setState(() => userType = type);
        },
        toggleAuthMode: () => setState(() => isLogin = !isLogin),
      );
    }
    if (userType == UserType.provider) {
      return ProviderDashboard(
        onLogout: () => setState(() {
          userType = null;
          isLogin = true;
        }),
      );
    }
    return UserDashboard(
      onLogout: () => setState(() {
        userType = null;
        isLogin = true;
      }),
    );
  }
}

/// Authentication UI for login/signup (User/Provider)
class AuthScreen extends StatelessWidget {
  final bool isLogin;
  final void Function(UserType) onAuthCompleted;
  final VoidCallback toggleAuthMode;

  const AuthScreen({
    super.key,
    required this.isLogin,
    required this.onAuthCompleted,
    required this.toggleAuthMode,
  });

  @override
  Widget build(BuildContext context) {
    final title = isLogin ? 'Sign In' : 'Sign Up';
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Electronic City Commuter Service',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        surfaceTintColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              _AuthForm(
                isLogin: isLogin,
                onSuccess: onAuthCompleted,
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: toggleAuthMode,
                child: Text(isLogin
                    ? "Don't have an account? Sign Up"
                    : "Already have an account? Log In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthForm extends StatefulWidget {
  final bool isLogin;
  final void Function(UserType) onSuccess;

  const _AuthForm({required this.isLogin, required this.onSuccess});

  @override
  State<_AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<_AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool isProvider = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _loading = false;
  String? _errorText;

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _errorText = null;
    });
    await Future.delayed(const Duration(milliseconds: 700)); // Simulated network
    // TODO: Replace this logic with real API calls for login/signup.
    setState(() => _loading = false);
    // For demo, succeed for any credentials.
    widget.onSuccess(isProvider ? UserType.provider : UserType.user);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!widget.isLogin)
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
            ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) =>
                v == null || !v.contains('@') ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _pwController,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (v) =>
                v == null || v.length < 4 ? 'Minimum 4 characters' : null,
          ),
          const SizedBox(height: 18),
          if (!widget.isLogin)
            SwitchListTile.adaptive(
              value: isProvider,
              onChanged: (v) => setState(() => isProvider = v),
              title: const Text('Register as Transport Provider'),
              contentPadding: EdgeInsets.zero,
            ),
          const SizedBox(height: 20),
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                _errorText!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: _loading
                  ? null
                  : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _submit();
                      }
                    },
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(widget.isLogin ? 'Sign In' : 'Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}

/// User Dashboard with Tab Navigation
class UserDashboard extends StatefulWidget {
  final VoidCallback onLogout;
  const UserDashboard({super.key, required this.onLogout});
  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 0;

  static final List<Widget> _tabs = [
    const HomeTab(),
    const ScheduleTab(),
    const BookingsTab(),
    const SubscriptionsTab(),
    const ProfileTab(isProvider: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: MainTabBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        isProvider: false,
      ),
    );
  }
}

/// Provider Dashboard with possible different tab contents
class ProviderDashboard extends StatefulWidget {
  final VoidCallback onLogout;
  const ProviderDashboard({super.key, required this.onLogout});
  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  int _currentIndex = 0;

  static final List<Widget> _tabs = [
    const ProviderHomeTab(),
    const ProviderScheduleTab(),
    const ProviderBookingsTab(),
    const ProviderSubscriptionsTab(),
    const ProfileTab(isProvider: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: MainTabBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        isProvider: true,
      ),
    );
  }
}

/// Common Main TabBar Widget
class MainTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isProvider;

  const MainTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isProvider,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Schedule'),
      const BottomNavigationBarItem(icon: Icon(Icons.event_note_outlined), label: 'Bookings'),
      BottomNavigationBarItem(
        icon: const Icon(Icons.subscriptions_outlined),
        label: isProvider ? 'My Service' : 'Subscriptions'
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
    ];
    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kAccentColor,
      unselectedItemColor: Colors.black54,
      backgroundColor: Colors.white,
      elevation: 10,
      onTap: onTap,
    );
  }
}

// ---- Tab Implementations ----

/// Home Tab for User
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTabPage(
      title: "Home",
      icon: Icons.home_outlined,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Welcome to Electronic City Commuter Service!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text('Browse schedule, manage bookings or subscriptions from the tabs below.'),
        ],
      ),
    );
  }
}

/// Provider Home Tab
class ProviderHomeTab extends StatelessWidget {
  const ProviderHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTabPage(
      title: "Provider Dashboard",
      icon: Icons.dashboard_customize_outlined,
      child: Column(
        children: const [
          SizedBox(height: 20),
          Text('Manage your active routes, trips, and view upcoming schedules.'),
        ],
      ),
    );
  }
}

/// Schedule Tab for Users (Calendar/List UI stub)
class ScheduleTab extends StatelessWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTabPage(
      title: "Schedule",
      icon: Icons.calendar_month_outlined,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.calendar_today, size: 28, color: kPrimaryColor),
                SizedBox(height: 10),
                Text('Trip Schedule will be shown here (Calendar/List).'),
                SizedBox(height: 10),
                Text(
                  'Select a date and see available slots.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Schedule Tab for Providers (Their service schedule)
class ProviderScheduleTab extends StatelessWidget {
  const ProviderScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTabPage(
      title: "Schedule",
      icon: Icons.calendar_month_outlined,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.directions_bus, size: 28, color: kPrimaryColor),
                SizedBox(height: 10),
                Text('Manage vehicle schedule, slots, and service timings.'),
                SizedBox(height: 10),
                Text(
                  'Add/edit times, track service usage.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bookings Tab (User)
class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTabPage(
      title: "Bookings",
      icon: Icons.event_note_outlined,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.event_available, size: 28, color: kSecondaryColor),
                SizedBox(height: 10),
                Text('Your active and past bookings will be listed here.'),
                SizedBox(height: 10),
                Text(
                  'Book or cancel trips and get real-time status.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bookings Tab (Provider)
class ProviderBookingsTab extends StatelessWidget {
  const ProviderBookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTabPage(
      title: "Bookings",
      icon: Icons.people_outline,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.people_outline, size: 28, color: kSecondaryColor),
                SizedBox(height: 10),
                Text('View and manage user bookings for your service.'),
                SizedBox(height: 10),
                Text(
                  'Approve/cancel bookings, monitor occupancy.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Subscriptions Tab (User)
class SubscriptionsTab extends StatelessWidget {
  const SubscriptionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTabPage(
      title: "Subscriptions",
      icon: Icons.subscriptions_outlined,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.subscriptions_outlined, size: 28, color: kAccentColor),
                SizedBox(height: 10),
                Text('Manage monthly subscriptions & view status.'),
                SizedBox(height: 10),
                Text(
                  'Subscribe, renew, or cancel your plan.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Subscriptions Tab (Provider)
class ProviderSubscriptionsTab extends StatelessWidget {
  const ProviderSubscriptionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTabPage(
      title: "My Service",
      icon: Icons.subscriptions_outlined,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.assignment_turned_in_outlined, size: 28, color: kAccentColor),
                SizedBox(height: 10),
                Text('See subscribers, manage pricing and plans.'),
                SizedBox(height: 10),
                Text(
                  'Overview of your service subscriptions.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Profile Tab for User/Provider
class ProfileTab extends StatelessWidget {
  final bool isProvider;
  const ProfileTab({super.key, this.isProvider = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isProvider ? 'Provider Profile' : 'Profile'),
        surfaceTintColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white,),
            onPressed: () {
              // Navigate back to login/signup by popping until root
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: Color.fromRGBO(
                  kPrimaryColor.r.toInt(), kPrimaryColor.g.toInt(), kPrimaryColor.b.toInt(), 0.2),
              child: Icon(
                isProvider ? Icons.directions_bus : Icons.person,
                size: 45,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isProvider ? 'Transport Provider' : 'User Profile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            const Divider(),
            const SizedBox(height: 14),
            _buildProfileRow('Name', 'John Doe'),
            _buildProfileRow('Email', 'user@example.com'),
            _buildProfileRow('Phone', '+91 9876543210'),
            if (isProvider) _buildProfileRow('Service Area', 'Electronic City'),
            if (isProvider) _buildProfileRow('Vehicles', '2'),
            if (!isProvider) _buildProfileRow('Subscription Status', 'Active'),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryColor,
                foregroundColor: Colors.white,
              ),
              label: const Text('Edit Profile'),
              onPressed: () {
                // TODO: Implement profile edit feature.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile editing not implemented')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: [
          SizedBox(
            width: 135,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

/// General-purpose wrapper for tab screens with consistent app bar and style.
class SimpleTabPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SimpleTabPage({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(icon, color: kAccentColor, size: 26),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
        surfaceTintColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}
