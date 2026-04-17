package web.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;
import java.util.Objects;

@Getter
@Setter
@ToString
@lombok.AllArgsConstructor

public class User {

    private String name;
    private ArrayList<TodoList> lists;

    public User(String n){
        this.name = n;
        this.lists = new ArrayList<>();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return name.equals(user.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }

    public void addTodoList(TodoList tl){
        this.lists.add(tl);
    }

    public void removeTodoList(TodoList tl){
        this.lists.remove(tl);
    }

    public TodoList findTodoList(String tl){
        for ( TodoList t : lists){
            if(t.getName().equals(tl)){
                return t;
            }
        }
        return null;
    }



}
