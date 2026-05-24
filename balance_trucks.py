def min_moves_to_balance(n, fuel):
    """
    Returns minimum moves to balance fuel across trucks.
    Each move transfers fuel from one truck to an adjacent neighbor.
    Each truck with surplus or deficit requires one move.
    """
    total = sum(fuel)
    if total % n != 0:
        return -1
    
    target = total // n
    moves = 0
    
    for f in fuel:
        if f != target:
            moves += 1
    
    return moves

if __name__ == "__main__":
    n1 = 5
    fuel1 = [10, 14, 12, 8, 16]
    print(f"Example 1: {min_moves_to_balance(n1, fuel1)}")  # Expected: 4
    
    n2 = 3
    fuel2 = [7, 8, 6]
    print(f"Example 2: {min_moves_to_balance(n2, fuel2)}")  # 21 is divisible by 3, should be 2

# Test cases
print(min_moves_to_balance(5, [10, 14, 12, 8, 16]))  # 4
print(min_moves_to_balance(3, [7, 8, 6]))            # 2 (not -1, 21%3==0)
print(min_moves_to_balance(3, [1, 1, 1]))            # 0 (already balanced)