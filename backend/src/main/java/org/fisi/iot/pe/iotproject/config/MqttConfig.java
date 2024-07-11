package org.fisi.iot.pe.iotproject.config;

import lombok.Data;
import org.eclipse.paho.client.mqttv3.IMqttClient;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.UUID;

@Configuration
@EnableConfigurationProperties
@ConfigurationProperties("mqtt")
@Data
public class MqttConfig {
    private String hostname;
    private String topic;
    @Bean
    @ConfigurationProperties(prefix = "mqtt.options")
    public MqttConnectOptions mqttConnectOptions() {
        return new MqttConnectOptions();
    }

    @Bean(name = "publisherChannel")
    public IMqttClient publisherChannel() throws MqttException {
        String clientID = createClientID(Constantes.ClientIDPrefix.PUBLISHER.getValue());
        IMqttClient mqttClient = new MqttClient(hostname, clientID);
        mqttClient.connect(mqttConnectOptions());
        return mqttClient;
    }

    @Bean(name = "subscriberChannel")
    public IMqttClient subscriberChannel() throws MqttException {
        String clientID = createClientID(Constantes.ClientIDPrefix.SUBSCRIBER.getValue());
        IMqttClient mqttClient = new MqttClient(hostname, clientID);
        mqttClient.connect(mqttConnectOptions());
        return mqttClient;
    }

    public static String createClientID(String prefixCode) {
        return prefixCode + UUID.randomUUID();
    }
}
