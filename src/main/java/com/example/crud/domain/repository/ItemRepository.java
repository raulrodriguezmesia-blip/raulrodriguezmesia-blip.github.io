package com.example.crud.domain.repository;

import com.example.crud.domain.model.Item;
import java.util.Optional;
import java.util.List;

public interface ItemRepository {
    Item save(Item item);
    Optional<Item> findById(Long id);
    List<Item> findAll();
    void deleteById(Long id);
}
