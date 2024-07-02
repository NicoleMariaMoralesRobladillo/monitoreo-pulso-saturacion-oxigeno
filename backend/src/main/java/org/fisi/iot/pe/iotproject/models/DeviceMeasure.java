package org.fisi.iot.pe.iotproject.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;
@Data
@AllArgsConstructor
@NoArgsConstructor
@Document(collection = "device")
@ToString
public class DeviceMeasure {
    @Id
    private String id;
    private Long heartRate;
    private Long spo2Rate;
    @CreatedDate
    private Date timestamp;

}
