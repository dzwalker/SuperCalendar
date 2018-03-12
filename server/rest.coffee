Meteor.publish("getUsers",
    (index)->
        return Todos.find()
    {
        url: "getUsers/:0"
        httpMethod: "get"
    }
)

Meteor.method("testPost",
    (a,b)->

        {title:""+a+1,detail:""+b+1}
    {
        url:"tp/"
        httpMethod: "post"
        getArgsFromRequest: (request)->
            body = request.body
            a = body.a
            b = body.b
            [a,b]

    }
)

Meteor.method("sync-todos",
    (userId,timeLastSync,newTodosIds)->
        todosFromServer = Todos.find({},{fields:{"title":1,"note":1}})
        todos = []
        todosFromServer.forEach((doc)->
            todos.push doc
        )
        timeSynced = 0
        return {todos:todos,timeSynced:timeSynced,newTodosIds:newTodosIds}
    {
        url:"sync-todos/"
        httpMethod: "get"
        getArgsFromRequest: (request)->
            request.body = {
                userId : 0
                timeLastSync : 1231212
                todos : [
                    {
                        syncType:0
                    }
                    {
                        syncType:1
                    }
                ]
            }
            content = request.body
            userId = content.userId
            timeLastSync = content.timeLastSync
            todosFromApp = content.todos
            newTodosIds = []
            for todo in todosFromApp
                switch todo.syncType
                    when 0
                        console.log 0
                    when 1
                        console.log 1
            return [userId,timeLastSync,newTodosIds]
    }
)
