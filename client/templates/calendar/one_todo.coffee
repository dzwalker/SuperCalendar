Template.oneTodo.helpers
    title:()->
        catagory = this.catagory
        settingTodo = Settings.findOne({name:'todo'}).value
        title = this.title
        catagory = settingTodo['catagories'][catagory]
        title = "【"+catagory+"】" + title
        title
    todoQuery:()->
        exam = Session.get("_exam")
        {_id:this._id,_exam:exam}
    isVisable:()->
        true
    queryString:()->
        query = {}
        _.extend(query,Template.parentData(5).data.query)
        $.param(query)
