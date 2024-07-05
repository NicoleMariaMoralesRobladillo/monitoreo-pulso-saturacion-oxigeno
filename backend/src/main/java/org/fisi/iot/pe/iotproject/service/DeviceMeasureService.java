package org.fisi.iot.pe.iotproject.service;

import org.fisi.iot.pe.iotproject.models.DeviceMeasure;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface DeviceMeasureService {

    ResponseEntity<List<DeviceMeasure>> filterByDate(String init, String end);
}
