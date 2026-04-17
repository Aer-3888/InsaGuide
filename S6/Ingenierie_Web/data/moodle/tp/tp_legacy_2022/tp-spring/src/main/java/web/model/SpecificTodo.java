package web.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;

@Getter
@Setter
@ToString(callSuper = true)

public class SpecificTodo extends Todo{

    private String mySpecificAttr;

    public SpecificTodo(){
        super();
        this.mySpecificAttr="";
    }

    public SpecificTodo(String title, String publicDescription, String privateDescription, ArrayList<Category> categories, String s) {
        super(title, publicDescription, privateDescription, categories);
        this.mySpecificAttr = s;
    }
}
