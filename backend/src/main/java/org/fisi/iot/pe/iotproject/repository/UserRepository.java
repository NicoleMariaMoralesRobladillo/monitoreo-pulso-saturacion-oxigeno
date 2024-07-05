package org.fisi.iot.pe.iotproject.repository;

import org.fisi.iot.pe.iotproject.models.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends MongoRepository<User, String> {
}
