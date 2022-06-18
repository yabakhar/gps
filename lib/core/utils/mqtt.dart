import '../modules/Hardiot.dart';
import 'Utils.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttClient {
  static final MqttClient _singleton = MqttClient._internal();
  late MqttServerClient client;
  factory MqttClient() {
    return _singleton;
  }

  MqttClient._internal();

  Future<bool> init(serverUrl, worker) async {
    client = MqttServerClient(serverUrl, '');
    client.setProtocolV311();
    client.logging(on: false);
    client.keepAlivePeriod = 5;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.onUnsubscribed = onUnSubscribed;
    final connMess = MqttConnectMessage()
        .authenticateAs(worker, "5!%csXkm\$np%o&")
        .withClientIdentifier(worker)
        .startClean()
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;
    client.autoReconnect = true;
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      try {
        await client.connect();
        print('MQTT Server connected ');
        return true;
      } catch (e) {
        print('Connection failed$e');
        return false;
      }
    } else {
      print('MQTT Server already connected ');
      return false;
    }
  }

  Future<void> onConnect() async {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      try {
        await client.connect();
      } catch (e) {
        print('Connection failed$e');
      }
    } else {
      print('MQTT Server already connected ');
    }
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void onUnSubscribed(String? topic) {
    print('EXAMPLE::onUnSubscribed confirmed for topic $topic');
  }

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void unsubscribe(String topic) {
    client.unsubscribe(topic);
  }

  void onMessage({getMessage}) {
    var dd = client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print(recMess.payload.message);
      Hardiot hardiot = Utils.decode(pt);
      getMessage(
        lat: hardiot.lat,
        lng: hardiot.lng,
        evc: hardiot.evc,
        lcid: hardiot.lcid,
        engineRpm: hardiot.engineRpm,
        fv: hardiot.fv,
        vehicleSpeed: hardiot.vehicleSpeed,
        engineLoad: hardiot.engineLoad,
        coolantTemp: hardiot.coolantTemp,
        odometer: hardiot.odometer,
        batLevel: hardiot.batLevel,
        exVoltage: hardiot.exVoltage,
        fuelLevel: hardiot.fuelLevel,
        csq: hardiot.csq,
      );
    });
  }
}
