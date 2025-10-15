import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../core/chuck_utils.dart';
import '../model/chuck_http_call.dart';
import '../model/chuck_http_error.dart';
import '../model/chuck_http_response.dart';
import '../ui/page/chuck_calls_list_screen.dart';

class ChuckCore {
  /// Should user be notified with notification if there's new request catched
  /// by Chuck
  final bool showNotification;

  /// Should inspector be opened on device shake (works only with physical
  /// with sensors)

  /// Should inspector use dark theme
  final bool darkTheme;

  /// Rx subject which contains all intercepted http calls
  final BehaviorSubject<List<ChuckHttpCall>> callsSubject = BehaviorSubject.seeded([]);

  /// Icon url for notification
  final String notificationIcon;

  ///Max number of calls that are stored in memory. When count is reached, FIFO
  ///method queue will be used to remove elements.
  final int maxCallsCount;

  ///Directionality of app. If null then directionality of context will be used.
  final TextDirection? directionality;

  /// Clear calls without confirming on delete button clicked
  final bool clearCallsWithoutConfirming;

  /// Show delete button on calls list screen AppBar
  final bool showDeleteButton;

  /// show and enable search feature on callse list screen AppBar
  final bool enableSearch;

  /// Show menu button on calls list screen AppBar
  final bool showMenuButton;

  GlobalKey<NavigatorState>? navigatorKey;
  Brightness _brightness = Brightness.light;
  bool _isInspectorOpened = false;
  StreamSubscription<dynamic>? _callsSubscription;
  String? _notificationMessage;
  String? _notificationMessageShown;

  /// Creates Chuck core instance
  ChuckCore(
    this.navigatorKey, {
    required this.showNotification,
    required this.darkTheme,
    required this.notificationIcon,
    required this.maxCallsCount,
    this.directionality,
    required this.clearCallsWithoutConfirming,
    required this.showDeleteButton,
    required this.enableSearch,
    required this.showMenuButton,
  }) {
    if (showNotification) {
      _callsSubscription = callsSubject.listen((_) => _onCallsChanged());
    }
    _brightness = darkTheme ? Brightness.dark : Brightness.light;
  }

  /// Dispose subjects and subscriptions
  void dispose() {
    callsSubject.close();
    _callsSubscription?.cancel();
  }

  /// Get currently used brightness
  Brightness get brightness => _brightness;

  void _onCallsChanged() async {
    if (callsSubject.value.isNotEmpty) {
      _notificationMessage = _getNotificationMessage();
      if (_notificationMessage != _notificationMessageShown) {
        _onCallsChanged();
      }
    }
  }

  /// Opens Http calls inspector. This will navigate user to the new fullscreen
  /// page where all listened http calls can be viewed.
  void navigateToCallListScreen() {
    final context = getContext();
    if (context == null) {
      ChuckUtils.log('Cant start Chuck HTTP Inspector. Please add NavigatorKey to your application');
      return;
    }
    if (!_isInspectorOpened) {
      _isInspectorOpened = true;
      Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => ChuckCallsListScreen(this),
        ),
      ).then((onValue) => _isInspectorOpened = false);
    }
  }

  /// Get context from navigator key. Used to open inspector route.
  BuildContext? getContext() => navigatorKey?.currentState?.overlay?.context;

  String _getNotificationMessage() {
    final List<ChuckHttpCall> calls = callsSubject.value;
    final int successCalls = calls
        .where((call) => call.response != null && call.response!.status! >= 200 && call.response!.status! < 300)
        .toList()
        .length;

    final int redirectCalls = calls
        .where((call) => call.response != null && call.response!.status! >= 300 && call.response!.status! < 400)
        .toList()
        .length;

    final int errorCalls = calls
        .where((call) => call.response != null && call.response!.status! >= 400 && call.response!.status! < 600)
        .toList()
        .length;

    final int loadingCalls = calls.where((call) => call.loading).toList().length;

    final StringBuffer notificationsMessage = StringBuffer();
    if (loadingCalls > 0) {
      notificationsMessage.write('Loading: $loadingCalls');
      notificationsMessage.write(' | ');
    }
    if (successCalls > 0) {
      notificationsMessage.write('Success: $successCalls');
      notificationsMessage.write(' | ');
    }
    if (redirectCalls > 0) {
      notificationsMessage.write('Redirect: $redirectCalls');
      notificationsMessage.write(' | ');
    }
    if (errorCalls > 0) {
      notificationsMessage.write('Error: $errorCalls');
    }
    String notificationMessageString = notificationsMessage.toString();
    if (notificationMessageString.endsWith(' | ')) {
      notificationMessageString = notificationMessageString.substring(0, notificationMessageString.length - 3);
    }

    return notificationMessageString;
  }

  /// Add Chuck http call to calls subject
  void addCall(ChuckHttpCall call) {
    final callsCount = callsSubject.value.length;
    if (callsCount >= maxCallsCount) {
      final originalCalls = callsSubject.value;
      final calls = List<ChuckHttpCall>.from(originalCalls);
      calls.sort((call1, call2) => call1.createdTime.compareTo(call2.createdTime));
      final indexToReplace = originalCalls.indexOf(calls.first);
      originalCalls[indexToReplace] = call;

      callsSubject.add(originalCalls);
    } else {
      callsSubject.add([...callsSubject.value, call]);
    }
  }

  /// Add error to existing Chuck http call
  void addError(ChuckHttpError error, int requestId) {
    final ChuckHttpCall? selectedCall = _selectCall(requestId);

    if (selectedCall == null) {
      ChuckUtils.log('Selected call is null');
      return;
    }

    selectedCall.error = error;
    callsSubject.add([...callsSubject.value]);
  }

  /// Add response to existing Chuck http call
  void addResponse(ChuckHttpResponse response, int requestId) {
    final ChuckHttpCall? selectedCall = _selectCall(requestId);

    if (selectedCall == null) {
      ChuckUtils.log('Selected call is null');
      return;
    }
    selectedCall.loading = false;
    selectedCall.response = response;
    selectedCall.duration = response.time.millisecondsSinceEpoch - selectedCall.request!.time.millisecondsSinceEpoch;

    callsSubject.add([...callsSubject.value]);
  }

  /// Add Chuck http call to calls subject
  void addHttpCall(ChuckHttpCall chuckHttpCall) {
    assert(chuckHttpCall.request != null, "Http call request can't be null");
    assert(chuckHttpCall.response != null, "Http call response can't be null");
    callsSubject.add([...callsSubject.value, chuckHttpCall]);
  }

  /// Remove all calls from calls subject
  void removeCalls() {
    callsSubject.add([]);
  }

  ChuckHttpCall? _selectCall(int requestId) => callsSubject.value.firstWhere((call) => call.id == requestId);
}
