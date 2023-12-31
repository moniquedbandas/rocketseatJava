package br.com.moniquedb.todolist2.user;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
//import java.util.List;
import java.util.List;



public interface IUserRepository extends JpaRepository<UserModel, UUID>{
    UserModel findByUsername(String username);
    List<UserModel> findAll();
}
