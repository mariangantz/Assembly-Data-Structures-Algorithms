## Assembly Data Structures

This document outlines the implementation details and high-level descriptions for three distinct tasks: **Parentheses Checking** (using a Stack), **Depth-First Search (DFS)** on a Graph, and the implementation of higher-order functions **Map and Reduce**.

---

## 1. Task 1: Balanced Parentheses Check

This code implements a function, `check_parantheses`, to verify the correctness of parenthesis pairing within a string using a **stack-based approach**.

### High-Level Description

The function determines the string's length and then iterates through each character. Opening parentheses are **pushed onto the stack**. When a closing parenthesis is found, it is compared with the most recent opening parenthesis on the stack. If they match, the opening parenthesis is **popped** (removed) from the stack; otherwise, it signals an error. Finally, the function checks if the stack is empty to determine if the parentheses are correctly balanced.

### Implementation Details

* **Data Section (`.data`):**
    * `paranteze`: Stores all types of parentheses to be checked (`"([{}])"`).
    * `stiva`: A **100-byte buffer** used as the stack to track open parentheses.
    * `lungime`: A 4-byte variable to store the string length.
* **Function Execution (`.text`):**
    * The `check_parantheses` function is globally accessible.
    * **Setup:** Registers (`ebp`, `esi`, `edi`, `ebx`) are saved and initialized.
    * The **string length** is calculated by iterating until the null terminator (`\0`) and stored in the `lungime` variable.
    * **Iteration and Stack Logic:**
        * If the character is an **opening parenthesis**, it is **pushed** onto the `stiva` buffer.
        * If the character is a **closing parenthesis**, it is compared with the element at the top of the stack.
        * If they match, the element is **popped** (removed) from the stack.
    * **Result:** The result is returned via the `eax` register: **0** for a balanced string, **1** otherwise.

---

## 2. Task 3: Depth-First Search (DFS) on a Graph

This code performs a **Depth-First Search (DFS)** on a graph, where the graph is represented by a vector of nodes and an `expand` function that returns the neighbors of a given node. The `printf` function is used to print each node as it is visited.

### Implementation Details

* **Data Structures:**
    * `neighbours_t`: A structure defined with fields `num_neighs` (number of neighbors) and `neighs` (address of the vector of neighbors).
    * `visited`: A **10000-element vector** declared in the `.bss` section to keep track of visited nodes.
* **Function Signature:**
    * The global `dfs` function has the C signature: `void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))`.
* **Execution Flow:**
    * **Setup:** The base pointer (`ebp`) and all other registers are saved (`pusha`).
    * The **current node** (`edi`) is marked as visited.
    * The current node is printed using `printf`.
    * **Neighbor Expansion:** The `expand` function is called with the current node to obtain its neighbors (a pointer to the `neighbours_t` structure).
    * **Search Loop (`CautaInGraf`):**
        * The loop iterates through each neighbor (`edx`).
        * A check is performed to see if the neighbor has already been visited.
        * If the neighbor is **not visited**, the `dfs` function is called **recursively** for that neighbor.
    * **Teardown:** Registers are restored (`popa`), and the function returns (`ret`).

---

## 3. Bonus Task: Higher-Order Functions (Map and Reduce)

This task implements the higher-order functions **`map`** and **`reduce`**, common in functional programming, to process elements in a source vector.

### 3.1. The `map` Function

**Description:** The `map` function iterates through every element in the **source vector** (`src`), applies a transformation function (`f`) to it, and stores the result in the **destination vector** (`dst`).

| Parameter | Register | Description |
| :---: | :---: | :--- |
| `f` | `rcx` | Address of the mapping function. |
| `src` | `rsi` | Pointer to the source vector. |
| `dst` | `rdi` | Pointer to the destination vector. |
| `n` | `rdx` | Number of elements in the source vector. |

**Implementation Flow:**
* **Initialization:** Counter (`r9`) is set to zero; destination address (`rbx`) is set.
* **Iteration:** The counter (`r9`) is compared with the number of elements (`rdx`).
* **Function Call:** For each element, the function `f` (`rcx`) is called, passing the current element from `src` (via `rdi`).
* **Result Storage:** The result of `f` is stored in the `dst` vector.
* **Cleanup:** Counter is incremented, and the process repeats until all elements are processed.

### 3.2. The `reduce` Function

**Description:** The `reduce` function combines the elements of the source vector (`src`) into a single value using the reduction function (`f`), starting from an initial accumulation value (`acc_init`). The final result is stored at the address pointed to by `dst`.

| Parameter | Register | Description |
| :---: | :---: | :--- |
| `dst` | `rdi` | Pointer to the final result location. |
| `src` | `rsi` | Pointer to the source vector. |
| `n` | `rdx` | Number of elements in the source vector. |
| `acc_init` | `rcx` | Initial accumulation value. |
| `f` | `r8` | Address of the reduction function. |

**Implementation Flow:**
* **Initialization:** Destination address (`rbx`), source address (`r9`), and initial accumulation value (`rax`) are set.
* **Iteration:** The counter (`r10`) is compared with the number of elements (`rdx`).
* **Function Call:** For each element, the reduction function `f` (`r8`) is called, passing the current accumulation (`rdi`) and the current element (`rsi`).
* **Accumulation Update:** The accumulation register (`rax`) is updated with the result of `f`.
* **Cleanup:** Counter is incremented, and the process repeats until all elements are processed.
