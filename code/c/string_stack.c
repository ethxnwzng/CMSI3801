#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "string_stack.h"

#define MIN_CAPACITY 16
#define INITIAL_CAPACITY 16

// Internal structure for the stack
struct _Stack {
    char** items;      // Array of string pointers
    int top;           // Index of top element (-1 if empty)
    int capacity;      // Current capacity
};

// Helper to check valid capacity bounds
// Returns success if resized, out_of_memory if realloc fails
static response_code resize_stack(stack s, int new_capacity) {
    // Safety clamp (though caller should handle this)
    if (new_capacity < MIN_CAPACITY) new_capacity = MIN_CAPACITY;
    if (new_capacity > MAX_CAPACITY) new_capacity = MAX_CAPACITY;

char** new_items = realloc(s->items, new_capacity * sizeof(char*));
    if (new_items == NULL) {
        return out_of_memory;
    }
    
    s->items = new_items;
    s->capacity = new_capacity;
    return success;
}

stack_response create() {
    stack_response res;
    
    // Allocate the stack struct
    stack s = malloc(sizeof *s);
    if (s == NULL) {
        res.code = out_of_memory;
        res.stack = NULL;
        return res;
    }
    
    // Allocate the internal array
    s->items = malloc(INITIAL_CAPACITY * sizeof(char*));    if (s->items == NULL) {
        free(s); // Prevent memory leak of the struct
        res.code = out_of_memory;
        res.stack = NULL;
        return res;
    }
    
    s->top = -1;
    s->capacity = INITIAL_CAPACITY;
    
    res.code = success;
    res.stack = s;
    return res;
}

int size(const stack s) {
    if (s == NULL) return 0;
    return s->top + 1;
}

bool is_empty(const stack s) {
    if (s == NULL) return true;
    return s->top == -1;
}

bool is_full(const stack s) {
    if (s == NULL) return false;
    return size(s) >= MAX_CAPACITY;
}

response_code push(stack s, char* item) {
    if (s == NULL || item == NULL) {
        return out_of_memory; // Or a specific error like invalid_argument if available
    }
    
    // Check string size limit
    size_t len = strlen(item);
    if (len >= MAX_ELEMENT_BYTE_SIZE) {
        return stack_element_too_large;
    }
    
    // Check logic: Are we currently full?
    if (s->top + 1 >= s->capacity) {
        // We need to grow
        if (s->capacity == MAX_CAPACITY) {
            return stack_full;
        }

        int new_capacity = s->capacity * 2;
        if (new_capacity > MAX_CAPACITY) new_capacity = MAX_CAPACITY;
        
        response_code rc = resize_stack(s, new_capacity);
        if (rc != success) return rc;
    }
    
    // Defensive copy: Deep copy the string into the stack
    char* copy = malloc(len + 1);
    if (copy == NULL) {
        return out_of_memory;
    }
    strcpy(copy, item);
    
    // Increment top and assign
    s->top++;
    s->items[s->top] = copy;
    
    return success;
}

string_response pop(stack s) {
    string_response res;
    
    if (s == NULL || is_empty(s)) {
        res.code = stack_empty;
        res.string = NULL;
        return res;
    }
    
    // 1. Grab the pointer directly. Ownership transfers to 'res'.
    char* item = s->items[s->top];
    
    // 2. Decrement top (effectively removing it from stack view)
    s->top--;
    
    // 3. Shrink logic
    // We check the size *after* the pop.
    int current_size = s->top + 1;
    
    // Spec: "shrink when popping to a size below one-fourth"
    if (s->capacity > MIN_CAPACITY && current_size * 4 < s->capacity) {
        int new_capacity = s->capacity / 2;
        if (new_capacity < MIN_CAPACITY) new_capacity = MIN_CAPACITY;
        
        resize_stack(s, new_capacity);
        // If resize fails during shrink, we don't error out the pop.
        // We just keep the larger capacity and return the item successfully.
    }
    
    res.code = success;
    res.string = item; // Return the original pointer
    return res;
}

void destroy(stack* s) {
    if (s == NULL || *s == NULL) {
        return;
    }
    
    // Free every string currently in the stack
    for (int i = 0; i <= (*s)->top; i++) {
        free((*s)->items[i]);
    }
    
    // Free the array of pointers
    free((*s)->items);
    
    // Free the struct
    free(*s);
    
    // Nullify the user's pointer
    *s = NULL;
}