package web.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import web.model.TodoList;
import web.model.User;
import web.services.TodoService;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.hasSize;
import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc

class TodoV2Test {
    @Autowired
    private MockMvc mvc;

    @Autowired
    private TodoService todoService;

    @Test
    void TestGetTodo() throws Exception{
        mvc.perform(get("/api/insa/v2/todo/Todo"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andDo(MockMvcResultHandlers.print())
                .andExpect(jsonPath("$.*", hasSize(4)))
                .andExpect(jsonPath("$.categories", hasSize(2)))
                .andExpect(jsonPath("$.categories[0]", equalTo("WORK")))
                .andExpect(jsonPath("$.categories[1]", equalTo("HIHG_PRIORITY")))
                .andExpect(jsonPath("$.title", equalTo("Devoir")));
    }

    @Test
    void TestPostTodo() throws Exception{
        mvc.perform(post("/api/insa/v2/todo/TodoJSON")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                    "title": "Devoir",
                                    "publicDescription": "Liste des devoirs",
                                    "privateDescription": "Il y en as beaucoup !",
                                    "categories": [
                                        "WORK",
                                        "HIHG_PRIORITY"
                                    ]
                                }
                                """)
        ).andExpect(status().isOk());
    }

    @Test
    void TestAddTodo() throws Exception{
        mvc.perform(post("/api/insa/v2/todo/newUser")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""                                
                                {
                                	"name" : "Leandre",
                                                                
                                	"lists" :\s
                                		[  \s
                                		    {
                                		        "name" : "Devoir",
                                				"todos" :
                                		        [
                                		            {
                                		                "title": "Maths",
                                		                "publicDescription": "Exo1",
                                		                "privateDescription": "Difficle",
                                		                "categories": ["WORK"]
                                		            },
                                		            {
                                                        "title": "Info",
                                                        "publicDescription": "Projet",
                                                        "privateDescription": "trouver un groupe",
                                                        "categories": ["WORK"]
                                		            }
                                		        ]
                                		    }
                                		]
                                }
                                """)
        ).andExpect(status().isOk());
        mvc.perform(post("/api/insa/v2/todo/todo/Leandre/Devoir")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""                                
                                
                                {
                                    "title": "Maths",
                                    "publicDescription": "Exo1",
                                    "privateDescription": "Difficle",
                                    "categories": ["WORK"]
                                }
                                """)
        ).andExpect(status().isOk());
    }

}