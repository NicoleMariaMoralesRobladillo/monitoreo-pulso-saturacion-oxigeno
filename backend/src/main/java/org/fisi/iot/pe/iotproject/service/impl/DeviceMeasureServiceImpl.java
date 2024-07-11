package org.fisi.iot.pe.iotproject.service.impl;

import lombok.RequiredArgsConstructor;
import org.fisi.iot.pe.iotproject.models.DeviceMeasure;
import org.fisi.iot.pe.iotproject.repository.DeviceRepository;
import org.fisi.iot.pe.iotproject.service.DeviceMeasureService;
import org.fisi.iot.pe.iotproject.util.DateUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DeviceMeasureServiceImpl implements DeviceMeasureService {
    private final DeviceRepository deviceRepository;
    @Override
    public ResponseEntity<List<DeviceMeasure>> filterByDate(String init, String end) {
        try {
            Date initDate = DateUtil.initOfDay(init, DateUtil.FORMAT_DATE_XML);
            Date endDate = DateUtil.endOfDay(end, DateUtil.FORMAT_DATE_XML);
            return ResponseEntity.ok(deviceRepository.findByTimestampBetween(initDate, endDate));
        } catch (Exception ex){
            return ResponseEntity.badRequest().build();
        }
    }
}
