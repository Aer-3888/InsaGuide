package web.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import web.DTO.TodoListDTO;
import web.model.Todo;
import web.model.TodoList;
import web.model.User;
import web.services.TodoService;

import java.util.List;
import java.util.ArrayList;

@RestController
@RequestMapping("/api/insa/v3/todo")

public class TodoV3 {

    private final TodoService todoService;

    public TodoV3(TodoService ts){
        this.todoService = ts;
    }

    @GetMapping(path="printTodo/{user}", produces = MediaType.TEXT_PLAIN_VALUE)
    public String afficherTodo(@PathVariable("user") String user){
        User u = todoService.findUser(user);
        ArrayList<Todo> userTodo = new ArrayList<>();
        for ( TodoList todoList : u.getLists()){
            for ( Todo todo : todoList.getTodos()){
                userTodo.add(todo);
            }
        }
        return userTodo.toString();
    }


    @GetMapping(path="findTodo/{user}/{todo}", produces = MediaType.TEXT_PLAIN_VALUE)
    public String rechercher2Todo(@PathVariable("user") String user, @PathVariable("todo") String todo){
        ArrayList<User> twoTodoUser = new ArrayList<>();
        for ( User u : todoService.getUsers()){
            int nbTodo = 0;
            for ( TodoList tl : u.getLists()){
                for ( Todo t : tl.getTodos()){
                    nbTodo++;
                }
                if (nbTodo>2){
                    twoTodoUser.add(u);
                }
            }
        }
        return twoTodoUser.toString();
    }

    @PostMapping(path="createUser", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void createUser(@RequestBody final User u){
        if(!todoService.getUsers().contains(u)){
            todoService.addUser(u);
        }else{
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "la requête n'a pas pu aboutir");
        }
        System.out.println(todoService.getUsers());
    }

    @PostMapping(path="createUser2", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public User createUser2(@RequestBody final String name){
        User u = new User(name);
        if(!todoService.getUsers().contains(u)){
            todoService.addUser(u);
        }else{
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "l'utilisateur est dans la base");
        }
        System.out.println(todoService.getUsers());
        return u;
    }

    @PostMapping(path="createTodoList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public TodoList createUser3(@RequestBody final TodoList tl){
        return tl;
    }


    @DeleteMapping(path="user/{name}")
    public void removeUser(@PathVariable("name") String name){
        for (User user : todoService.getUsers()){
            if(user.getName().equals(name)){
                todoService.deleteUser(user);
                System.out.println(todoService.getUsers());
                return;
            }
        }
    }

    @PostMapping(path = "todo/{userName}/{todolistName}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void addTodo(@RequestBody Todo t, @PathVariable("userName") String userName, @PathVariable("todolistName") String todolistName){
        User u = todoService.findUser(userName);
        if(u != null){
            TodoList tl = u.findTodoList(todolistName);
            if(tl != null){
                tl.addTodo(t);
                System.out.println(todoService.getUsers());
            }else {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "La todoList n'est pas dans la liste");
            }
        }else{
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "L'utilisateur n'est pas dans la liste");
        }

    }

    @DeleteMapping(path = "todo/{user}/{todolist}/{todo}")
    public void removeTodo(@PathVariable("user") String user, @PathVariable("todolistName") String todolist, @PathVariable("todo") String todo){
        User u = todoService.findUser(user);
        TodoList tl = u.findTodoList(todolist);
        for(Todo t : tl.getTodos()){
            if(t.getTitle().equals(todo)){
                tl.removeTodo(t);
                System.out.println(todoService.getUsers());
                return;
            }
        }
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, todo + " n'est pas dans la liste de " + user);

    }

    @GetMapping(path = "getTodo/{user}", produces = MediaType.TEXT_PLAIN_VALUE)
    public String getTodoListName(@PathVariable("user") String user){
        User u = todoService.findUser(user);
        List<TodoListDTO> list = new ArrayList<>();
        for ( TodoList tl : u.getLists()){
            list.add( new TodoListDTO(tl));
        }
        return list.toString();
    }



}
