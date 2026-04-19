# Stacks & Queues

## Theorie

Les piles et files sont des structures de donnees a **acces restreint**. Elles sont largement utilisees dans le cours SDD comme briques de base pour les algorithmes (evaluation d'expressions, BFS, Dijkstra, notation polonaise inverse).

### Pile (Stack) -- LIFO

**Dernier entre, premier sorti.** Pensez a une pile d'assiettes.

```
  push(C)    push(D)    pop() -> D    pop() -> C
  +---+      +---+      +---+         +---+
  | C |      | D |      | C |         | B |
  +---+      +---+      +---+         +---+
  | B |      | C |      | B |         | A |
  +---+      +---+      +---+         +---+
  | A |      | B |      | A |
  +---+      +---+      +---+
             | A |
             +---+
```

Operations :
- `push(x)` -- ajouter au sommet : O(1)
- `pop()` -- retirer du sommet : O(1)
- `peek()` -- voir le sommet sans retirer : O(1)
- `isEmpty()` -- verifier si vide : O(1)

### File (Queue) -- FIFO

**Premier entre, premier sorti.** Pensez a une file d'attente dans un magasin.

```
  enqueue(A)  enqueue(B)  enqueue(C)  dequeue() -> A
  front                                front
   |                                    |
  [A]        [A][B]      [A][B][C]     [B][C]
```

Operations :
- `enqueue(x)` -- ajouter a l'arriere : O(1)
- `dequeue()` -- retirer de l'avant : O(1)
- `peek()` -- voir l'avant sans retirer : O(1)
- `isEmpty()` -- verifier si vide : O(1)


## Implementations

### Pile avec tableau

```java
public class StackArray<T> {
    private Object[] data;
    private int top = -1;

    public StackArray(int capacity) {
        data = new Object[capacity];
    }

    public void push(T item) {
        if (top == data.length - 1) throw new StackOverflowError();
        data[++top] = item;
    }

    @SuppressWarnings("unchecked")
    public T pop() {
        if (top == -1) throw new EmptyStackException();
        T item = (T) data[top];
        data[top--] = null;
        return item;
    }

    @SuppressWarnings("unchecked")
    public T peek() {
        if (top == -1) throw new EmptyStackException();
        return (T) data[top];
    }

    public boolean isEmpty() { return top == -1; }
}
```

### Pile avec liste chainee

```java
public class StackLinked<T> {
    private static class Node<T> {
        T value;
        Node<T> next;
        Node(T v, Node<T> n) { value = v; next = n; }
    }

    private Node<T> top = null;

    public void push(T item) {
        top = new Node<>(item, top);  // new node points to old top
    }

    public T pop() {
        if (top == null) throw new EmptyStackException();
        T val = top.value;
        top = top.next;
        return val;
    }

    public T peek() {
        if (top == null) throw new EmptyStackException();
        return top.value;
    }

    public boolean isEmpty() { return top == null; }
}
```

### File avec tableau circulaire

```java
public class QueueCircular<T> {
    private Object[] data;
    private int front = 0, rear = 0, size = 0;

    public QueueCircular(int capacity) {
        data = new Object[capacity];
    }

    public void enqueue(T item) {
        if (size == data.length) throw new RuntimeException("Full");
        data[rear] = item;
        rear = (rear + 1) % data.length;
        size++;
    }

    @SuppressWarnings("unchecked")
    public T dequeue() {
        if (size == 0) throw new RuntimeException("Empty");
        T item = (T) data[front];
        data[front] = null;
        front = (front + 1) % data.length;
        size--;
        return item;
    }

    public boolean isEmpty() { return size == 0; }
}
```


## Applications dans le cours SDD

### 1. Notation Polonaise Inverse (Reverse Polish Notation)

Utilisee dans le TP6 (ExprArith) et le TP8 (Le Compte est Bon). Une pile evalue les expressions postfixes.

```
Expression: (3 + 4) * 2
Postfix:     3 4 + 2 *

Evaluation with stack:
  Read 3  -> push 3        Stack: [3]
  Read 4  -> push 4        Stack: [3, 4]
  Read +  -> pop 4, pop 3  Stack: []
             push 3+4=7    Stack: [7]
  Read 2  -> push 2        Stack: [7, 2]
  Read *  -> pop 2, pop 7  Stack: []
             push 7*2=14   Stack: [14]
  Result: 14
```

Extrait de ExprArith.evaluer() (TP6) -- evaluation recursive par arbre, pas par pile NPI :
```java
private double recursiveEvaluation(Arbre root) {
    Arbre gauche = root.arbreG();
    Arbre droit = root.arbreD();
    String renter = (String) root.racine();

    if (gauche.estVide() || droit.estVide()) {
        // Leaf: return numeric value or variable
        try { return Double.parseDouble(renter); }
        catch (NumberFormatException e) {}
        return this.valeur(renter);
    } else {
        double dgauche = recursiveEvaluation(gauche);
        double ddroite = recursiveEvaluation(droit);
        switch (renter) {
            case "+": return dgauche + ddroite;
            case "-": return dgauche - ddroite;
            case "*": return dgauche * ddroite;
            case "/": return dgauche / ddroite;
            default: throw new IllegalArgumentException("UNKNOWN OPERATION");
        }
    }
}
```

### 2. BFS (Breadth-First Search) -- Queue

```
Graph:  A --- B --- D
        |         |
        C --- E ---

BFS from A using a queue:
  Queue: [A]           Visited: {A}
  Dequeue A, enqueue B,C
  Queue: [B, C]        Visited: {A, B, C}
  Dequeue B, enqueue D
  Queue: [C, D]        Visited: {A, B, C, D}
  Dequeue C, enqueue E
  Queue: [D, E]        Visited: {A, B, C, D, E}
  ...

Order: A, B, C, D, E  (level by level)
```

### 3. DFS (Depth-First Search) -- Stack

```
DFS from A using a stack:
  Stack: [A]           Visited: {A}
  Pop A, push C, B
  Stack: [C, B]        Visited: {A}  -> visit A
  Pop B, push D
  Stack: [C, D]        Visited: {A, B}
  Pop D, push E
  Stack: [C, E]        Visited: {A, B, D}
  Pop E
  Stack: [C]           Visited: {A, B, D, E}
  Pop C
  Stack: []            Visited: {A, B, D, E, C}

Order: A, B, D, E, C  (goes deep first)
```

### 4. Dijkstra -- File de priorite (voir Chapitres 6-7)

Dijkstra utilise une **file de priorite** (tas min) qui est une file specialisee ou le retrait retourne toujours l'element minimum.


## Bibliotheque standard Java

| Structure | Classe Java | Methodes cles |
|-----------|------------|---------------|
| Pile | `java.util.ArrayDeque` | `push()`, `pop()`, `peek()` |
| File | `java.util.ArrayDeque` | `offer()`, `poll()`, `peek()` |
| File de priorite | `java.util.PriorityQueue` | `add()`, `poll()`, `peek()` |

Note : `java.util.Stack` existe mais est obsolete. Preferer `ArrayDeque`.

```java
Deque<Integer> stack = new ArrayDeque<>();
stack.push(1);  // add to top
stack.push(2);
int top = stack.pop();  // 2

Deque<Integer> queue = new ArrayDeque<>();
queue.offer(1);  // add to back
queue.offer(2);
int front = queue.poll();  // 1
```


## Complexite

| Operation | Pile tableau | Pile chainee | File circulaire | File chainee |
|-----------|-------------|-------------|-----------------|-------------|
| push/enqueue | O(1)* | O(1) | O(1) | O(1) |
| pop/dequeue | O(1) | O(1) | O(1) | O(1) |
| peek | O(1) | O(1) | O(1) | O(1) |
| isEmpty | O(1) | O(1) | O(1) | O(1) |
| Space | O(n) | O(n) | O(n) | O(n) |

*O(1) amorti si le tableau necessite un redimensionnement.


## AIDE-MEMOIRE

```
STACK (LIFO)                         QUEUE (FIFO)
============                         ============
push(x): add to top                  enqueue(x): add to back
pop():   remove from top             dequeue():  remove from front
peek():  see top                     peek():     see front

APPLICATIONS:
  Stack: DFS, expression eval, undo, recursion simulation
  Queue: BFS, scheduling, buffering
  PriorityQueue: Dijkstra, heap sort, task scheduling

POSTFIX EVALUATION (stack):
  For each token:
    number -> push
    operator -> pop 2, compute, push result
  Final answer = pop

JAVA:
  Deque<T> stack = new ArrayDeque<>();   // push, pop, peek
  Deque<T> queue = new ArrayDeque<>();   // offer, poll, peek
```
