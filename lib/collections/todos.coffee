root = exports ? this
root.Todos = new Mongo.Collection('todos')

# type:大的分类，目前用到的有event, weekly,
# userId这个字段，当是用户的时候，就是用户，当是科目的时候，就是科目
# 先有type, 再有catagory
# catagory先查一下有没有声明，没有的话就直接用名称来显示

Meteor.methods

    todoInsert: (todoAttributes)->
        # weekly的任务的结束时间全部设定为周日的23:59:59.00
        check(Meteor.userId(), String)
        if 'note' of todoAttributes
            check(todoAttributes,{userId:String, type: Number,catagory:String, title:String, note:String, duetime:Date}) #所有插入的内容都要在这里声名
            _.extend(todoAttributes,{
                submitted : new Date()
                updatedAt : new Date()
                idInApp : 0
                status:0
                star:0
            })
        else
            check(todoAttributes,{userId:String, type: Number,catagory:String, title:String, duetime:Date}) #所有插入的内容都要在这里声名
            _.extend(todoAttributes,{
                submitted : new Date()
                updatedAt : new Date()
                idInApp : 0
                note:''
                status:0
                star:0
            })
        todoId = Todos.insert(todoAttributes)
        return {_id : todoId}
    todoUpdate:(todoId,updateProperties)->
        _.extend(updateProperties,{updatedAt : new Date()})
        Todos.update({_id:todoId},{$set:updateProperties},(error)->
            if error
                console.log error
            )
        null
    todoStarIt:(todoId)->
        Todos.update({_id:todoId},{$set:{star:1}},(error)->
            if error
                console.log error
            )
        null

    todoUnstarIt:(todoId)->
        Todos.update({_id:todoId},{$set:{star:0}},(error)->
            if error
                console.log error
            )
        null
    todoDelIt:(todoId)->
        Todos.update({_id:todoId},{$set:{status:9}},(error)->
            if error
                console.log error
            )
        null
