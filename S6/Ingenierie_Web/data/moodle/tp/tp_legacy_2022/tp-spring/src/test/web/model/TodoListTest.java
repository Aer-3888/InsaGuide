package web.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;
import static web.model.Category.WORK;

class TodoListTest {

    private TodoList tl;

    @BeforeEach
    void SetUp(){
        this.tl = new TodoList("Devoir");
    }

    @Test
    void TestFindTodo(){
        assertNull(tl.findTodo("lele"));
        Todo todo = new Todo("Maths", "Exo1", "Difficile", new ArrayList<Category>(Collections.singleton(WORK)) );
        tl.addTodo(todo);
        assertEquals(todo, tl.findTodo("Maths"));
    }
}