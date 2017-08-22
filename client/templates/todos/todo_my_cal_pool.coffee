Template.todoMyCalPool.helpers
    todosInPool:()->
        queryReminders =
            type : 4
        todos = Todos.find(queryReminders,{sort:{duetime:1}})
        todos
