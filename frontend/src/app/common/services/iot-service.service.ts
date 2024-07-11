import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { environment } from "../../environment/environment";
import { firstValueFrom } from "rxjs";
import { IDataMeasure } from "../models/data";

@Injectable({providedIn: 'root'})
export class IotService {
  public constructor(private http: HttpClient) {}

  public filterMeasures(params: any) {
    return firstValueFrom(this.http.get<IDataMeasure[]>(`${environment.apiUrl}/measures/filter`, {params: params}));
  }
}