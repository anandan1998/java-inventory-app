package com.inventory.config;

import com.inventory.model.Role;
import com.inventory.repository.RoleRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final RoleRepository roleRepository;

    @Override
    public void run(String... args) {
        try {
            // Initialize roles if they don't exist
            if (roleRepository.count() == 0) {
                log.info("Initializing default roles...");

                Role userRole = new Role();
                userRole.setName(Role.RoleName.ROLE_USER);
                userRole.setDescription("Standard user with read access to view products and categories");
                roleRepository.save(userRole);

                Role managerRole = new Role();
                managerRole.setName(Role.RoleName.ROLE_MANAGER);
                managerRole.setDescription("Manager with read/write access to manage inventory");
                roleRepository.save(managerRole);

                Role adminRole = new Role();
                adminRole.setName(Role.RoleName.ROLE_ADMIN);
                adminRole.setDescription("Administrator with full access to all system features");
                roleRepository.save(adminRole);

                log.info("Default roles initialized successfully");
            } else {
                log.info("Roles already exist, skipping initialization");
            }
        } catch (Exception e) {
            log.error("Error initializing data: {}", e.getMessage());
        }
    }
}
