package web.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import web.model.*;

import java.awt.*;
import java.util.ArrayList;

import static web.model.Category.HIHG_PRIORITY;
import static web.model.Category.WORK;

@RestController //marque la classe comme étant une ressource REST
@RequestMapping("api/insa/v1/todo") //def l'URI de la ressource REST

public class TodoV1 {

    private ArrayList<User> users;
    public TodoV1(){
        users = new ArrayList<>();
    }


    @GetMapping(path = "hello", produces = MediaType.TEXT_PLAIN_VALUE)
    public String hello(){
        return "hello";
    }

    //http://localhost:8080/api/insa/v1/todo/hello sur internet pour ouvrir la page
    //dans un terminal dans le dossier : curl http://localhost:8080/api/insa/v1/todo/hello
    //sur postman, ajouter une request et mettre en URL : http://localhost:8080/api/insa/v1/todo/hello

    @GetMapping(path="Todo", produces = MediaType.APPLICATION_JSON_VALUE)
    public Todo heloworld(){
        ArrayList<Category> c = new ArrayList();
        c.add(WORK);
        c.add(HIHG_PRIORITY);
        return new Todo("Devoir","Liste des devoirs", "Il y en as beaucoup !", c );
    }


    @PostMapping(path="TodoJSON", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void newTodoJSON(@RequestBody final Todo t){
        System.out.println(t);
    }

    @PostMapping(path="TodoListJSON", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void newTodoListJSON(@RequestBody final TodoList l){
        System.out.println(l);
    }

    @PostMapping(path="newUser", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void newUser(@RequestBody final User u){
        //System.out.println(u);
        if(!users.contains(u)){
            users.add(u);
        }else{
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "la requête n'a pas pu aboutir");
        }
        System.out.println(users);
    }

    @PatchMapping(path="user/{name}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void patchUser(@RequestBody User patchedUser, @PathVariable("name") String name){
        for (User user : users){
            if(patchedUser.getName().equals(user.getName())){
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, name + " est déjà dans la liste ");
            }
        }
        for (User user : users){
            if(user.getName().equals(name)){
                user.setName(patchedUser.getName());
                //user.setLists(patchedUser.getLists());
                System.out.println(users);
                return;
            }
        }
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, name + " n'est pas dans la liste des users");
    }

    //Si un seul user peut accéder à la todoList c'est une bonne pratique sinon ça ne l'est pas, pb si plusieurs personnes modifient en même temps un user

    @DeleteMapping(path="user/{name}")
    public void removeUser(@PathVariable("name") String name){
        for (User user : users){
            if(user.getName().equals(name)){
                users.remove(user);
                System.out.println(users);
                return;
            }
        }
    }

    @GetMapping(path="findUser/{name}")
    public User findUser(@PathVariable("name") String name){
        for ( User user : users){
            if(user.getName().equals(name)){
                return user;
            }
        }
        return null;
    }

    @PostMapping(path="todoList/{userName}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void addTodoList(@RequestBody TodoList tl, @PathVariable("userName") String name){
        for ( User user : users){
            if ( user.getName().equals(name)){
                user.addTodoList(tl);
                System.out.println(users);
                return;
            }
        }
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, name + " n'est pas un utilisateur de la liste");
    }

    public Todo findTodo(String userName, String todolistName, String todoName){
        User u = findUser(userName);
        TodoList tl = u.findTodoList(todolistName);
        Todo t = tl.findTodo(todoName);
        return t;
    }

    @PostMapping(path = "todo/{userName}/{todolistName}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void addTodo(@RequestBody Todo t, @PathVariable("userName") String userName, @PathVariable("todolistName") String todolistName){
        User u = findUser(userName);
        TodoList tl = u.findTodoList(todolistName);
        tl.addTodo(t);
        System.out.println(users);
    }







}
