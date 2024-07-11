export interface IDataMeasure {
    id?: string;
    validHR?: number;
    heartRate?: number;
    spo2Rate?: number;
    validSP02?: number;
    timestamp: Date;
}

export interface  DataItem {
    name: string;
    value: [string, number];
  }