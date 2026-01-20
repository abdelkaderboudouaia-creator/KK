import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../Helper/app_const.dart';
import 'package:flutter/material.dart';



class NotificationApi {


  late WebSocketChannel channel;
  final _controller = StreamController<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> connect() async* {
    final token = AppConst.prefs.getString('token');
    final userId = AppConst.prefs.getInt('userId');

    if (token == null || userId == null) {
      debugPrint('❌ Missing token or userId. Token: ${token != null ? "exists" : "null"}, UserId: $userId');
      return;
    }

    final serverUrl = 'ws://q-play.in:8080/app/oj28ontxuzecqrml9por';
    final authEndpoint = '${AppConst.endPoint}/broadcasting/auth';
    final channelName = 'private-notifications.$userId';

    debugPrint('🔗 Attempting WebSocket connection to: $serverUrl');
    debugPrint('📺 Channel name: $channelName');
    debugPrint('🔐 Auth endpoint: $authEndpoint');

    try {
      final channel = IOWebSocketChannel.connect(Uri.parse(serverUrl));
      debugPrint('✅ WebSocket channel created successfully');

      await for (final message in channel.stream) {
        debugPrint('📨 Raw message received: $message');

        try {
          final data = jsonDecode(message);
          debugPrint('📋 Parsed message event: ${data['event']}');

          if (data['event'] == 'pusher:ping') {
            channel.sink.add(jsonEncode({'event': 'pusher:pong'}));
            debugPrint('🏓 Sent pong response');
            continue;
          }

          if (data['event'] == 'pusher:connection_established') {
            final socketId = jsonDecode(data['data'])['socket_id'];
            debugPrint('🔌 Connection established. Socket ID: $socketId');

            try {
              debugPrint('🔐 Sending auth request to: $authEndpoint');
              debugPrint('📤 Auth payload: socket_id=$socketId, channel=$channelName');

              final authResponse = await http.post(
                Uri.parse(authEndpoint),
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
                body: jsonEncode({
                  'socket_id': socketId,
                  'channel_name': channelName,
                }),
              );

              debugPrint('📥 Auth response status: ${authResponse.statusCode}');
              debugPrint('📥 Auth response headers: ${authResponse.headers}');
              debugPrint('📥 Auth response body: ${authResponse.body}');

              if (authResponse.statusCode == 200) {
                final authData = jsonDecode(authResponse.body);
                debugPrint('✅ Auth successful. Auth data keys: ${authData.keys}');

                final subscribeMessage = {
                  'event': 'pusher:subscribe',
                  'data': {
                    'auth': authData['auth'],
                    'channel': channelName,
                  }
                };

                debugPrint('📡 Sending subscribe message: ${jsonEncode(subscribeMessage)}');
                channel.sink.add(jsonEncode(subscribeMessage));
                debugPrint('📡 Subscribed to $channelName');
              } else {
                debugPrint('❌ Auth failed: ${authResponse.statusCode} ${authResponse.body}');
              }
            } catch (e) {
              debugPrint('❌ Auth error: $e');
              debugPrint('❌ Auth error stack trace: ${StackTrace.current}');
            }
            continue;
          }

          if (data['event'] == 'pusher:subscription_succeeded') {
            debugPrint('✅ Successfully subscribed to channel: $channelName');
            continue;
          }

          if (data['event'] == 'pusher:subscription_error') {
            debugPrint('❌ Subscription error: ${data['data']}');
            continue;
          }

          if (data['event'] == 'NotificationCreated') {
            debugPrint('🔔 NotificationCreated event received');
            final payload = data['data'];
            debugPrint('📦 Payload type: ${payload.runtimeType}');
            debugPrint('📦 Payload content: $payload');

            if (payload is String) {
              final decoded = jsonDecode(payload) as Map<String, dynamic>;
              debugPrint('✅ Yielding decoded string payload: $decoded');
              yield decoded;
            } else if (payload is Map<String, dynamic>) {
              debugPrint('✅ Yielding map payload: $payload');
              yield payload;
            } else {
              debugPrint('⚠️ Unexpected payload type: ${payload.runtimeType}');
            }
          } else {
            debugPrint('🔍 Unhandled event: ${data['event']}');
          }

        } catch (jsonError) {
          debugPrint('❌ JSON decode error: $jsonError');
          debugPrint('❌ Raw message that failed: $message');
        }
      }
    } catch (connectionError) {
      debugPrint('❌ WebSocket connection error: $connectionError');
      debugPrint('❌ Connection error stack trace: ${StackTrace.current}');
    }
  }

  void disconnect() {
    channel.sink.close();
    _controller.close();
  }

  Future<http.Response> getNotifications() async {
    try{
      return await http.get(
        Uri.parse('${AppConst.endPoint}/notifications'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AppConst.prefs.getString('token')}'
        },
      );
    }
    catch(e){
      AppConst.prefs = await SharedPreferences.getInstance();
      return await http.get(
        Uri.parse('${AppConst.endPoint}/notifications'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AppConst.prefs.getString('token')}'
        },
      );
    }
  }

  Future<http.Response> readNotification({required int notificationId}) async {

    return await http.post(
        Uri.parse('${AppConst.endPoint}/read-notification'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AppConst.prefs.getString('token')}',

        },
        body: jsonEncode({
          'notification_id' : notificationId
        })
    );
  }

  Future<http.Response> readAllNotification() async {

    return await http.post(
      Uri.parse('${AppConst.endPoint}/read-all-notification'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AppConst.prefs.getString('token')}',
      },
    );
  }
}