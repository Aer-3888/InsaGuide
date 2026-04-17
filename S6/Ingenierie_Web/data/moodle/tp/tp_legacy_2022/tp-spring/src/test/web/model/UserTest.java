package web.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;
import static web.model.Category.WORK;

class UserTest {

    private User user;

    @BeforeEach
    void SetUp(){
        user = new User("Leandre");
    }

    @Test
    void TestFindTodoList(){
        assertNull(user.findTodoList("lele"));
        TodoList tl = new TodoList("Devoir");
        user.addTodoList(tl);
        assertEquals(tl, user.findTodoList("Devoir"));


    }



}