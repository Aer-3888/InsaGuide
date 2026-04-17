package web.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;

@Getter
@Setter
@ToString
@lombok.AllArgsConstructor //constructeur

public class TodoList {

    private String name;
    private ArrayList<Todo> todos;

    public TodoList(){
        this.name="";
        this.todos=new ArrayList<>();
    }

    public TodoList(String n){
        this.name = n;
        this.todos = new ArrayList<>();
    }

    public Todo findTodo(String t){
        for ( Todo todo : todos){
            if(todo.getTitle().equals(t)){
                return todo;
            }
        }
        return null;
    }

    public void addTodo(Todo t){
        this.todos.add(t);
    }

    public void removeTodo(Todo t){
        this.todos.remove(t);
    }

}


