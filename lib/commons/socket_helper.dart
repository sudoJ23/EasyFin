import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class SocketManager {
  static final SocketManager singleton = SocketManager._internal();
  SocketManager._internal();
  IO.Socket? socket;
  bool logged = false;
  static SocketManager get shared => singleton;

  Future<bool> waitTillConnected() async {
    return socket!.connected;
  }

  Future<void> initSocket() async {
    socket = IO.io("https://banking.billingmikrotik.com", <String, dynamic> {
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'timeout': 5000,
      'reconnectionAttempts': 5,
    });
    
    socket?.on("connect", (data) {
      if (kDebugMode) {
        print("Socket connected");
      }
    });

    socket?.on("connect_error", (data) {
      if (kDebugMode) {
        print("Socket connect_error");
        print("Gagal terhubung");
        print(data);
      }
    });

    socket?.on("error", (data) {
      if (kDebugMode) {
        print("Socket error");
        print(data);
      }
    });

    socket?.on("disconnect", (data) {
      if (kDebugMode) {
        print("Socket disconnected");
      }
    });
  }
}