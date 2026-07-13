package com.example.crud.infrastructure.persistence.file;

import com.example.crud.domain.model.Item;
import com.example.crud.domain.repository.ItemRepository;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.nio.file.Files;
import java.nio.file.Paths;

public class FileItemRepository implements ItemRepository {

    private final String filePath;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public FileItemRepository(String filePath) {
        this.filePath = filePath;
        // Ensure file exists
        File file = new File(filePath);
        if (!file.exists()) {
            try {
                Files.createDirectories(Paths.get(filePath).getParent());
                Files.writeIfAbsent(Paths.get(filePath), "[]".getBytes());
            } catch (IOException e) {
                throw new RuntimeException("Failed to initialize storage file", e);
            }
        }
    }

    @Override
    public Item save(Item item) {
        List<Item> items = findAllInternal();
        if (item.getId() == null) {
            Long newId = items.isEmpty() ? 1L : items.stream().mapToLong(Item::getId).max().orElse(0) + 1;
            item.setId(newId);
        }
        // remove if exists with same id
        items.removeIf(i -> i.getId().equals(item.getId()));
        items.add(item);
        saveAll(items);
        return item;
    }

    @Override
    public java.util.Optional<Item> findById(Long id) {
        return findAllInternal().stream()
                .filter(item -> item.getId().equals(id))
                .findFirst();
    }

    @Override
    public java.util.List<Item> findAll() {
        return findAllInternal();
    }

    @Override
    public void deleteById(Long id) {
        List<Item> items = findAllInternal();
        items.removeIf(item -> item.getId().equals(id));
        saveAll(items);
    }

    private List<Item> findAllInternal() {
        try {
            byte[] jsonData = Files.readAllBytes(Paths.get(filePath));
            if (jsonData.length == 0) {
                return new ArrayList<>();
            }
            return objectMapper.readValue(jsonData, new TypeReference<List<Item>>() {});
        } catch (IOException e) {
            throw new RuntimeException("Failed to read items from file", e);
        }
    }

    private void saveAll(List<Item> items) {
        try {
            String json = objectMapper.writeValueAsString(items);
            Files.write(Paths.get(filePath), json.getBytes());
        } catch (IOException e) {
            throw new RuntimeException("Failed to write items to file", e);
        }
    }
}
