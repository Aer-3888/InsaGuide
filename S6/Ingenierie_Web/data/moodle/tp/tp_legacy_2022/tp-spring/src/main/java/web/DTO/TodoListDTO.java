package web.DTO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import web.model.TodoList;

@Getter
@Setter
@ToString

public class TodoListDTO {

    private String name;

    public TodoListDTO(TodoList todoList){
        this.name = todoList.getName();
    }

}
