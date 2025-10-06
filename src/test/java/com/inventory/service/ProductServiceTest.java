package com.inventory.service;

import com.inventory.dto.ProductRequest;
import com.inventory.dto.ProductResponse;
import com.inventory.exception.DuplicateResourceException;
import com.inventory.exception.ResourceNotFoundException;
import com.inventory.model.Category;
import com.inventory.model.Product;
import com.inventory.repository.CategoryRepository;
import com.inventory.repository.ProductRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProductServiceTest {

    @Mock
    private ProductRepository productRepository;

    @Mock
    private CategoryRepository categoryRepository;

    @Mock
    private NotificationService notificationService;

    @InjectMocks
    private ProductService productService;

    private Category testCategory;
    private Product testProduct;
    private ProductRequest testRequest;

    @BeforeEach
    void setUp() {
        testCategory = new Category();
        testCategory.setId(1L);
        testCategory.setName("Electronics");
        testCategory.setDescription("Electronic items");

        testProduct = new Product();
        testProduct.setId(1L);
        testProduct.setSku("TEST-001");
        testProduct.setName("Test Product");
        testProduct.setDescription("Test Description");
        testProduct.setPrice(new BigDecimal("99.99"));
        testProduct.setQuantity(100);
        testProduct.setReorderLevel(10);
        testProduct.setCategory(testCategory);
        testProduct.setStatus("ACTIVE");

        testRequest = new ProductRequest();
        testRequest.setSku("TEST-001");
        testRequest.setName("Test Product");
        testRequest.setDescription("Test Description");
        testRequest.setPrice(new BigDecimal("99.99"));
        testRequest.setQuantity(100);
        testRequest.setReorderLevel(10);
        testRequest.setCategoryId(1L);
        testRequest.setStatus("ACTIVE");
    }

    @Test
    void createProduct_Success() {
        // Arrange
        when(productRepository.existsBySku(anyString())).thenReturn(false);
        when(categoryRepository.findById(1L)).thenReturn(Optional.of(testCategory));
        when(productRepository.save(any(Product.class))).thenReturn(testProduct);

        // Act
        ProductResponse response = productService.createProduct(testRequest);

        // Assert
        assertNotNull(response);
        assertEquals("TEST-001", response.getSku());
        assertEquals("Test Product", response.getName());
        verify(productRepository, times(1)).save(any(Product.class));
    }

    @Test
    void createProduct_DuplicateSku_ThrowsException() {
        // Arrange
        when(productRepository.existsBySku(anyString())).thenReturn(true);

        // Act & Assert
        assertThrows(DuplicateResourceException.class, () -> {
            productService.createProduct(testRequest);
        });
        verify(productRepository, never()).save(any(Product.class));
    }

    @Test
    void createProduct_CategoryNotFound_ThrowsException() {
        // Arrange
        when(productRepository.existsBySku(anyString())).thenReturn(false);
        when(categoryRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(ResourceNotFoundException.class, () -> {
            productService.createProduct(testRequest);
        });
        verify(productRepository, never()).save(any(Product.class));
    }

    @Test
    void getProductById_Success() {
        // Arrange
        when(productRepository.findById(1L)).thenReturn(Optional.of(testProduct));

        // Act
        ProductResponse response = productService.getProductById(1L);

        // Assert
        assertNotNull(response);
        assertEquals(1L, response.getId());
        assertEquals("TEST-001", response.getSku());
        verify(productRepository, times(1)).findById(1L);
    }

    @Test
    void getProductById_NotFound_ThrowsException() {
        // Arrange
        when(productRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(ResourceNotFoundException.class, () -> {
            productService.getProductById(1L);
        });
    }

    @Test
    void updateStock_LowStock_SendsNotification() {
        // Arrange
        testProduct.setQuantity(5); // Below reorder level
        when(productRepository.findById(1L)).thenReturn(Optional.of(testProduct));
        when(productRepository.save(any(Product.class))).thenReturn(testProduct);

        // Act
        ProductResponse response = productService.updateStock(1L, 5);

        // Assert
        assertNotNull(response);
        assertEquals(5, response.getQuantity());
        verify(notificationService, times(1)).sendLowStockAlert(any(Product.class));
    }

    @Test
    void deleteProduct_Success() {
        // Arrange
        when(productRepository.findById(1L)).thenReturn(Optional.of(testProduct));
        doNothing().when(productRepository).delete(any(Product.class));

        // Act
        productService.deleteProduct(1L);

        // Assert
        verify(productRepository, times(1)).delete(testProduct);
    }
}
