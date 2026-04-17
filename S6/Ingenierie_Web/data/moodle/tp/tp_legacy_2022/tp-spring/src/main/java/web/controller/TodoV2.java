package web.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import web.model.Category;
import web.model.Todo;
import web.model.TodoList;
import web.model.User;
import web.services.TodoService;

import java.util.ArrayList;

import static web.model.Category.HIHG_PRIORITY;
import static web.model.Category.WORK;

@RestController //marque la classe comme étant une ressource REST
@RequestMapping("api/insa/v2/todo") //def l'URI de la ressource REST

public class TodoV2 {

    //Mauvaise pratique de contenir les données dans les contrôleurs REST car si plusieurs versions de contrôleur => donnée centralisée et non partagé
    //un contrôleur gère les routes et un service gère les données
    //Le contrôleur utilise le service pour accéder aux données

    //meme service en commun
    //problème de centralisation
    private final TodoService todoService;
    public TodoV2(TodoService service){
        //todoService = new TodoService();
        //mauvaise pratique d'instancié un service directement dans le contrôleur pour la même raison. Si chaque contrôleur à son service, il n'y a pas de centralisation.
        this.todoService = service;
        todoService.setUsers(new ArrayList<>());
    }

    //C'est le framework Spring qui instancie les contrôleurs et les services


    @GetMapping(path = "hello", produces = MediaType.TEXT_PLAIN_VALUE)
    public String hello(){
        return "hello";
    }

    //http://localhost:8080/api/insa/v1/todo/hello sur internet pour ouvrir la page
    //dans un terminal dans le dossier : curl http://localhost:8080/api/insa/v1/todo/hello
    //sur postman, ajouter une request et mettre en URL : http://localhost:8080/api/insa/v1/todo/hello

    @GetMapping(path="todo", produces = MediaType.APPLICATION_JSON_VALUE)
    public Todo heloworld(){
        ArrayList<Category> c = new ArrayList();
        c.add(WORK);
        c.add(HIHG_PRIORITY);
        return new Todo("Devoir","Liste des devoirs", "Il y en as beaucoup !", c );
    }


    @PostMapping(path="todoJSON", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void newTodoJSON(@RequestBody final Todo t){
        System.out.println(t);
    }

    @PostMapping(path="todoListJSON", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void newTodoListJSON(@RequestBody final TodoList l){
        System.out.println(l);
    }

    @PostMapping(path="newUser", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void newUser(@RequestBody final User u){
        //System.out.println(u);
        if(!todoService.getUsers().contains(u)){
            todoService.addUser(u);
        }else{
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "la requête n'a pas pu aboutir");
        }
        System.out.println(todoService.getUsers());
    }

    @PatchMapping(path="user/{name}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void patchUser(@RequestBody User patchedUser, @PathVariable("name") String name){
        for (User user : todoService.getUsers()){
            if(patchedUser.getName().equals(user.getName())){
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, name + " est déjà dans la liste ");
            }
        }
        for (User user : todoService.getUsers()){
            if(user.getName().equals(name)){
                user.setName(patchedUser.getName());
                //user.setLists(patchedUser.getLists());
                System.out.println(todoService.getUsers());
                return;
            }
        }
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, name + " n'est pas dans la liste des users");
    }

    //Si un seul user peut accéder à la todoList c'est une bonne pratique sinon ça ne l'est pas, pb si plusieurs personnes modifient en même temps un user

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


    @PostMapping(path="todoList/{userName}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void addTodoList(@RequestBody TodoList tl, @PathVariable("userName") String name){
        for ( User user : todoService.getUsers()){
            if ( user.getName().equals(name)){
                user.addTodoList(tl);
                System.out.println(todoService.getUsers());
                return;
            }
        }
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, name + " n'est pas un utilisateur de la liste");
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


}
