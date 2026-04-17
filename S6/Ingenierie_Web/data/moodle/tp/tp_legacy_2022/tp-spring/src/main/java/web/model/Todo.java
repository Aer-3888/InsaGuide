package web.model;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;

@Getter
@Setter
@ToString
@JsonSubTypes({
        @JsonSubTypes.Type(value = Todo.class, name = "Todo"),
        @JsonSubTypes.Type(value=SpecificTodo.class, name="SpecificTodo")
})
@JsonTypeInfo(use=JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "Type")

public class Todo {

    private String title;
    private String publicDescription;
    private String privateDescription;
    private ArrayList<Category> categories;

    public Todo() {
        this.title="";
        this.publicDescription="";
        this.privateDescription="";
        this.categories=new ArrayList<>();
    }

    public Todo(String title, String publicDescription, String privateDescription, ArrayList<Category> categories) {
        this.title = title;
        this.publicDescription = publicDescription;
        this.privateDescription = privateDescription;
        this.categories = categories;
    }


}
