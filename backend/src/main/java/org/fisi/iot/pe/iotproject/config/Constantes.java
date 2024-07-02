package org.fisi.iot.pe.iotproject.config;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

public class Constantes {
    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public enum ClientIDPrefix{
        PUBLISHER("arduinitos-api-pub-"), SUBSCRIBER("arduinitos-api-sub-");
        private String value;
    }


}
