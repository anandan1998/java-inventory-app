package com.inventory.service;

import com.inventory.model.Product;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class NotificationService {

    @Async
    public void sendLowStockAlert(Product product) {
        log.info("Sending low stock alert for product: {} (SKU: {}), Current quantity: {}, Reorder level: {}",
                product.getName(), product.getSku(), product.getQuantity(), product.getReorderLevel());
        
        // Simulate sending email or notification
        try {
            Thread.sleep(1000); // Simulate delay
            log.info("Low stock alert sent successfully for product: {}", product.getName());
        } catch (InterruptedException e) {
            log.error("Error sending notification", e);
            Thread.currentThread().interrupt();
        }
    }

    @Async
    public void sendInventoryReport() {
        log.info("Generating and sending inventory report asynchronously...");
        
        // Simulate report generation
        try {
            Thread.sleep(2000); // Simulate delay
            log.info("Inventory report generated and sent successfully");
        } catch (InterruptedException e) {
            log.error("Error generating report", e);
            Thread.currentThread().interrupt();
        }
    }

    @Async
    public void processProductUpdate(Long productId, String action) {
        log.info("Processing product update asynchronously - Product ID: {}, Action: {}", productId, action);
        
        try {
            Thread.sleep(500); // Simulate processing
            log.info("Product update processed successfully - Product ID: {}", productId);
        } catch (InterruptedException e) {
            log.error("Error processing product update", e);
            Thread.currentThread().interrupt();
        }
    }
}
