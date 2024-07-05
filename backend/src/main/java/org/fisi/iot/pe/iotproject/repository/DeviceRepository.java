package org.fisi.iot.pe.iotproject.repository;

import org.fisi.iot.pe.iotproject.models.DeviceMeasure;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

import java.util.Date;
import java.util.List;

@Repository
public interface DeviceRepository extends MongoRepository<DeviceMeasure, String> {
    //Query to get all the measures between two dates
    @Query("{'timestamp': {$gte: ?0, $lte: ?1}}")
    List<DeviceMeasure> findByTimestampBetween(Date init, Date end);
}
