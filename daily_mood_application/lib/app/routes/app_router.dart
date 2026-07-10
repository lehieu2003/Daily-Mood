import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/security/app_lock_cubit.dart';
import '../../core/security/pin_repository.dart';
import '../../core/database/daos/activity_dao.dart';
import '../../features/mood_tracker/cubit/mood_form_cubit.dart';
import '../../features/mood_tracker/quick_log/quick_log_screen.dart';
import '../../features/settings/lock/lock_screen.dart';
import '../../features/settings/pin_setup/pin_setup_cubit.dart';
import '../../features/settings/pin_setup/pin_setup_screen.dart';
import '../../features/shell/main_shell.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  static const pinSetup = '/pin-setup';
  static const lock = '/lock';
  static const home = '/home';
  static const quickLog = '/log';
}

/// Builds the app's GoRouter, wiring redirects to [AppLockCubit] so
/// every route (present and future) is guarded automatically — no
/// individual screen needs to remember to check the lock state itself.
GoRouter buildAppRouter(AppLockCubit lockCubit, PinRepository pinRepository) {
  const gateLocations = {AppRoutes.splash, AppRoutes.pinSetup, AppRoutes.lock};

  return GoRouter(
    initialLocation: AppRoutes.splash,
    // Re-evaluates the redirect whenever the lock state changes, e.g.
    // when appResumed() decides to re-lock the app, or setup completes.
    refreshListenable: _CubitRefreshStream(lockCubit),
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final lockState = lockCubit.state;

      switch (lockState.status) {
        case LockStatus.checking:
          return loc == AppRoutes.splash ? null : AppRoutes.splash;
        case LockStatus.needsSetup:
          return loc == AppRoutes.pinSetup ? null : AppRoutes.pinSetup;
        case LockStatus.locked:
          return loc == AppRoutes.lock ? null : AppRoutes.lock;
        case LockStatus.unlocked:
          // Only force a redirect away from the "gate" screens; leave
          // the user wherever they legitimately are otherwise.
          return gateLocations.contains(loc) ? AppRoutes.home : null;
      }
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashPlaceholder(),
      ),
      GoRoute(
        path: AppRoutes.pinSetup,
        builder: (context, state) => BlocProvider(
          create: (_) => PinSetupCubit(
            pinRepository: pinRepository,
            appLockCubit: lockCubit,
          ),
          child: const PinSetupScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.lock,
        builder: (context, state) => const LockScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainShell(),
      ),
      GoRoute(
        path: AppRoutes.quickLog,
        builder: (context, state) => BlocProvider(
          create: (_) => MoodFormCubit(),
          child: QuickLogScreen(
            activities: context.read<ActivityDao>().watchActiveActivities(),
            onDone: () => context.pop(),
          ),
        ),
      ),
    ],
  );
}

/// Bridges a Cubit's stream to GoRouter's ChangeNotifier-based
/// refreshListenable, so a lock/unlock/setup emission re-runs the
/// redirect.
class _CubitRefreshStream extends ChangeNotifier {
  _CubitRefreshStream(AppLockCubit cubit) {
    _subscription = cubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class _SplashPlaceholder extends StatelessWidget {
  const _SplashPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
