package org.fisi.iot.pe.iotproject.models;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "user")
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class User {
    @Id
    private String id;
    private String username;
    private String password;
    private String email;
    private String code;
}
