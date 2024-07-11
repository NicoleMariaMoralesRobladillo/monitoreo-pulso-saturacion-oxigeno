import { Component, OnInit } from '@angular/core';
import { ChartModule } from 'primeng/chart';
import { MenubarModule } from 'primeng/menubar';
import { NavbarPortalComponent } from '../navbar-portal/navbar-portal.component';
import { NgxEchartsDirective, provideEcharts } from 'ngx-echarts';
import { IotService } from '../common/services/iot-service.service';
import { DataItem, IDataMeasure } from '../common/models/data';
import { IClientSubscribeOptions } from 'mqtt-browser';
import { ButtonModule } from 'primeng/button';

import { EChartsOption } from 'echarts';
import e from 'express';
import { NgIf } from '@angular/common';
import { IMqttMessage, IMqttServiceOptions, MqttConnectionState, MqttService } from 'ngx-mqtt';
import { Subscription } from 'rxjs';
import { MyMqttService } from '../common/services/mqtt-service.service';
import { Form, FormBuilder, FormGroup, ReactiveFormsModule } from '@angular/forms';
@Component({
  selector: 'app-portal',
  standalone: true,
  imports: [ChartModule, MenubarModule, NavbarPortalComponent, NgxEchartsDirective, NgIf, ReactiveFormsModule,ButtonModule],
  providers: [
    provideEcharts(),
  ],
  templateUrl: './portal.component.html',
  styleUrl: './portal.component.scss'
})
export class PortalComponent implements OnInit {
  public dataBack: IDataMeasure[] = [];
  public data: DataItem[] = [];
  public timeSerieGraph!: EChartsOption;
  public heartRate: number = 0;
  public spo2Rate: number = 0;
  public timeSerieGraph2!: EChartsOption;
  public topicSub!: Subscription;
  public loading = true;
  public mqttConnectionSub!: Subscription;
  public filter!: FormGroup;

 
  public constructor(private iotService: IotService, private mqttService: MyMqttService, private fb: FormBuilder) {
    this.filter = fb.group({
      init: [''],
      end: ['']
    }); 
  }
  exportToCsv() {
    const columns = this.getColumns(this.dataBack);
    const csvData = this.convertToCsv(this.dataBack, columns);
    this.downloadFile(csvData, 'data.csv', 'text/csv');
  }

  getColumns(data: any[]): string[] {
    const columns: string[] = [];
    data.forEach(row => {
      Object.keys(row).forEach(col => {
        if (!columns.includes(col)) {
          columns.push(col);
        }
      });
    });
    return columns;
  }

  convertToCsv(data: any[], columns: string[]): string {
    let csv = '';
    csv += columns.join(',') + '\n';
    data.forEach(row => {
      const values: any[] = [];
      columns.forEach(col => {
        values.push(row[col] || '');
      });
      csv += values.join(',') + '\n';
    });
    return csv;
  }

  downloadFile(data: string, filename: string, type: string) {
    const blob = new Blob([data], { type: type });
    if ((window.navigator as any).msSaveOrOpenBlob) {
      (window.navigator as any).msSaveBlob(blob, filename);
    } else {
      const link = document.createElement('a');
      link.setAttribute('href', URL.createObjectURL(blob));
      link.setAttribute('download', filename);
      link.style.visibility = 'hidden';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }
  }
  public buscar(){
    const init = this.filter.get('init')?.value;
    const end = this.filter.get('end')?.value;
    this.iotService.filterMeasures({init, end}).then(data=>{
      this.dataBack = data;
      this.data = this.dataBack.map((d) => {
        return {
          name: new Date(d.timestamp).toString(),
          value: [new Date(d.timestamp).getTime().toString(), d.spo2Rate || 0] as [string, number]
        };
      });
      this.setGraphSPO2();
      this.setGraphHR();
    });
  }
  public async ngOnInit() {
    const end = new Date();
    const init = new Date();
    init.setDate(end.getDate() - 1);
    const initFormatted = init.toISOString().split('T')[0]; // 'YYYY-MM-DD'
    const endFormatted = end.toISOString().split('T')[0]; // 'YYYY-MM-DD'
    this.dataBack = await this.iotService.filterMeasures({ init: initFormatted, end: endFormatted });
    this.data = this.dataBack.map((d) => {
      return {
        name: new Date(d.timestamp).toString(),
        value: [new Date(d.timestamp).getTime().toString(), d.spo2Rate || 0] as [string, number]
      };
    });
    this.setGraphSPO2();
    this.setGraphHR();
    this.mqttConnectionSub = this.mqttService
      .connect()
      .subscribe((connectionState: MqttConnectionState) => {
        switch (connectionState) {
          case MqttConnectionState.CLOSED:
            this.writeLog('CONEXIÓN CERRADA, REINTENTANDO...');
            break;
          case MqttConnectionState.CONNECTING:
            this.writeLog('CONECTANDO...');
            break;
          case MqttConnectionState.CONNECTED:
            this.writeLog('🟢 CONECTADO');
            break;
        }
      });
    this.toSubcribeToTopic();
    this.loading = false;
  }

  public toSubcribeToTopic(){
    if(this.topicSub && !this.topicSub.closed){
      this.topicSub.unsubscribe();
      this.writeLog(`ELIMINADA SUBSCRIPCIÓN A health1`);
      return;
    } 
    this.topicSub= this.mqttService.topic('health1').subscribe(message=>{
      const messageUTF8=new TextDecoder('utf-8').decode(message.payload);
      const data=JSON.parse(messageUTF8) as IDataMeasure;
      if(data.validHR){
        this.heartRate = data.heartRate || 0;
      }
      if(data.validSP02){
        this.spo2Rate = data.spo2Rate || 0;
      }
      this.writeLog(`RECIBIDO: ${messageUTF8} 👈`)
    });
    this.writeLog(`SUBSCRITO AL TOPIC 'health1'`);
  }
  private formatHour(date: Date): string {
    const formatHour: string = `0${date.getHours()}`.toString().slice(-2);
    const formatMinute: string = `0${date.getMinutes()}`.toString().slice(-2);
    const formatSecond: string = `0${date.getSeconds()}`.toString().slice(-2);
  
    return `${formatHour}:${formatMinute}:${formatSecond}`;
  }
  private writeLog(message: string): void {
    const now = new Date();
    const writeMessage = `${this.formatHour(now)} -> ${message}`;
    console.log(writeMessage);
  }
  public setGraphHR(): void {
    this.timeSerieGraph2 = {
      title: {
        text: 'HR Rate',
      },
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          animation: false
        }
      },
      xAxis: {
        type: 'time',
        splitLine: {
          show: false
        }
      },
      yAxis: {
        type: 'value',
        boundaryGap: [0, '100%'],
        splitLine: {
          show: false
        }
      },
      series: [
        {
          name: 'SPO2 Rate',
          type: 'line',
          showSymbol: false,
          data: this.dataBack.map((d) => {
            return [new Date(d.timestamp).getTime(), d.heartRate || 0];
          }),
        }
      ]
    };

  }
  public setGraphSPO2(): void {
    this.timeSerieGraph = {
      title: {
        text: 'SPO2 Rate',
      },
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          animation: false
        }
      },
      xAxis: {
        type: 'time',
        splitLine: {
          show: false
        }
      },
      yAxis: {
        type: 'value',
        boundaryGap: [0, '100%'],
        splitLine: {
          show: false
        }
      },
      series: [
        {
          name: 'SPO2 Rate',
          type: 'line',
          showSymbol: false,
          data: this.dataBack.map((d) => {
            return [new Date(d.timestamp).getTime(), d.spo2Rate || 0];
          }),
        }
      ]
    };

  }
}
function saveAs(blob: Blob, arg1: string) {
  throw new Error('Function not implemented.');
}

