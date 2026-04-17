package web.services;

import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import web.model.Todo;
import web.model.TodoList;
import web.model.User;

import java.util.ArrayList;

@Getter
@Setter
@Service

public class TodoService {

    private ArrayList<User> users;

    public TodoService(){
        this.users = new ArrayList<>();
    }

    public void addUser(User u){
        this.users.add(u);
    }

    public void deleteUser(User u){
        this.users.remove(u);
    }

    public User findUser(String name){
        for ( User user : users){
            if(user.getName().equals(name)){
                return user;
            }
        }
        return null;
    }

    public Todo findTodo(String userName, String todolistName, String todoName){
        User u = findUser(userName);
        TodoList tl = u.findTodoList(todolistName);
        Todo t = tl.findTodo(todoName);
        return t;
    }
}
