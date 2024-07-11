import { Injectable } from '@angular/core';
import { IMqttMessage, MqttConnectionState, MqttService, IMqttServiceOptions } from 'ngx-mqtt';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MyMqttService {

  

  constructor(private ngxMqttService: MqttService) { 
  
  }

  public connect():Observable<MqttConnectionState>{
    const MQTT_SERVICE_OPTIONS: IMqttServiceOptions = {
      hostname: '64.23.217.53',
      port: 9001,
      protocol: 'ws',
      path: '/mqtt'
    };
    this.ngxMqttService.connect(MQTT_SERVICE_OPTIONS);

    return this.ngxMqttService.state;
  }

  topic(topicName: string): Observable<IMqttMessage> {     
    return this.ngxMqttService.observe(topicName);
  }

  sendmsg(topicName:string, message:string): void {
    // use unsafe publish for non-ssl websockets
    this.ngxMqttService.unsafePublish(`${topicName}`, `${message}`, { qos: 2, retain: true })
    //qos: 0 como mucho una
    //qos: 1 como mínimo una
    //qos: 2 justo una
  }

}