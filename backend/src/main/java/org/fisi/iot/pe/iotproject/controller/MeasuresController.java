package org.fisi.iot.pe.iotproject.controller;

import lombok.RequiredArgsConstructor;
import org.fisi.iot.pe.iotproject.filter.MeasureFilter;
import org.fisi.iot.pe.iotproject.models.DeviceMeasure;
import org.fisi.iot.pe.iotproject.service.DeviceMeasureService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/measures")
@RequiredArgsConstructor
public class MeasuresController {
    private final DeviceMeasureService deviceMeasureService;
    @GetMapping(value = "/filter")
    public ResponseEntity<List<DeviceMeasure>> filterDevices(MeasureFilter filter){
        return deviceMeasureService.filterByDate(filter.getInit(), filter.getEnd());
    }
}
