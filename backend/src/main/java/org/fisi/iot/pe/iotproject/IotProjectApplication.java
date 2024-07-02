package org.fisi.iot.pe.iotproject;


import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@SpringBootApplication
@AutoConfiguration
@EnableMongoRepositories
public class IotProjectApplication implements CommandLineRunner {

	public static void main(String[] args) {
		SpringApplication.run(IotProjectApplication.class, args);
	}


	@Override
	public void run(String... args) throws Exception {

	}
}
