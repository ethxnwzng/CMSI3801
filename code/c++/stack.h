#include <stdexcept>
#include <string>
#include <memory>
#include <utility>  // For std::unreachable in C++23

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T>
class Stack {
  // Allocate the data array with a smart pointer, so no destructor needed
  std::unique_ptr<T[]> elements;
  int capacity;
  int top;

  // Prohibit copying and assignment
  Stack(const Stack&) = delete;
  Stack& operator=(const Stack&) = delete;
  Stack(Stack&&) = delete;
  Stack& operator=(Stack&&) = delete;

public:
  // constructor
  Stack() : capacity(INITIAL_CAPACITY), top(-1) {
    elements = std::make_unique<T[]>(capacity);
  }

  // size
  int size() const {
    [[assume(top >= -1)]];
    return top + 1;
  }

  // is_empty
  bool is_empty() const {
    return top == -1;
  }

  // is_full
  bool is_full() const {
    return size() == MAX_CAPACITY;
  }

  // push
  void push(const T& value) {
    if (is_full()) {
      throw std::overflow_error("Stack has reached maximum capacity");
      std::unreachable();  // C++23: marks unreachable code after throw
    }
    
    // If we need more space, reallocate
    if (top + 1 >= capacity) {
      reallocate();
      [[assume(capacity >= top + 1)]];  // C++23: optimization hint
    }
    
    top++;
    [[assume(top >= 0 && top < capacity)]];
    elements[top] = value;
  }

  // pop
  T pop() {
    if (is_empty()) {
      throw std::underflow_error("cannot pop from empty stack");
      std::unreachable();  // C++23: marks unreachable code after throw
    }
    
    [[assume(top >= 0 && top < capacity)]];
    T value = elements[top];
    top--;
    return value;
  }

private:
  // reallocate
  void reallocate() {
    [[assume(capacity > 0)]];
    int new_capacity = capacity * 2;
    if (new_capacity > MAX_CAPACITY) {
      new_capacity = MAX_CAPACITY;
      [[assume(new_capacity == MAX_CAPACITY)]];
    }
    
    auto new_elements = std::make_unique<T[]>(new_capacity);
    [[assume(top >= 0)]];
    for (int i = 0; i <= top; i++) {
      new_elements[i] = elements[i];
    }
    
    elements = std::move(new_elements);
    capacity = new_capacity;
    [[assume(capacity >= top + 1)]];
  }
};
