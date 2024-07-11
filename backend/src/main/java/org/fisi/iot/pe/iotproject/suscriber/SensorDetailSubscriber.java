package org.fisi.iot.pe.iotproject.suscriber;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.eclipse.paho.client.mqttv3.IMqttClient;
import org.fisi.iot.pe.iotproject.config.MqttConfig;
import org.fisi.iot.pe.iotproject.models.DeviceMeasure;
import org.fisi.iot.pe.iotproject.repository.DeviceRepository;
import org.mapstruct.Qualifier;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

@Component
@RequiredArgsConstructor
@Slf4j
public class SensorDetailSubscriber  implements CommandLineRunner {
    private final IMqttClient subscriberChannel;
    private final MqttConfig config;
    private final DeviceRepository deviceRepository;


    @Override
    public void run(String... args) throws Exception {
        CountDownLatch receivedSignal = new CountDownLatch(1);
        onSpO2(receivedSignal);
        receivedSignal.await(1, TimeUnit.MINUTES);
    }
    @Transactional
    public void onSpO2(CountDownLatch receivedSignal) throws Exception {
        subscriberChannel.subscribe(config.getTopic(), (topic, msg) -> {
            ObjectMapper  objectMapper= new ObjectMapper();
            String payload = new String(msg.getPayload());
            DeviceMeasure deviceMeasure = objectMapper.readValue(payload, DeviceMeasure.class);
            deviceMeasure.setTimestamp(new Date());
            //JSONObject jsonmsg = new JSONObject(new String(m.getPayload());
            deviceRepository.save(deviceMeasure);
            log.info("[Read Value] ReadValue " + payload + topic + deviceMeasure);
            receivedSignal.countDown();
        });
    }
}
