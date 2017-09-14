Template.todoMyCalOneDay.helpers
    cssToday:()->
        if this.isSame(moment(0,"hh"), 'day')
            return "cssToday"
        null

    queryString:()->
        query = {date:this.format("YYYYMMDD")}
        _.extend(query,Template.parentData(3).data.query)
        $.param(query)
    dateString:()->
        this.format("YYYYMMDD")
    date:()->
        this.format("MM/DD")
    thisDayReminders:()->
        today = this

        todoUserId = Session.get("todoUserId")
        queryReminders =
            userId : todoUserId
            duetime:{
                $gte: today.clone().toDate()
                $lt: today.clone().add(1,"days").toDate()
            }
            type : 1
        viewMode = Session.get("todoViewMode")
        if viewMode is 0
            _.extend(queryReminders,{status:0})
        todos = Todos.find(queryReminders,{sort:{duetime:1}})
        todos

    thisDayTodos:()->
        today = this
        todoUserId = Session.get("todoUserId")
        queryReminders =
            userId : todoUserId
            duetime:{
                $gte: today.clone().toDate()
                $lt: today.clone().add(1,"days").toDate()
            }
            type : 2
        viewMode = Session.get("todoViewMode")
        if viewMode is 0
            _.extend(queryReminders,{status:0})
        todos = Todos.find(queryReminders,{sort:{duetime:1}})
        todos
    isShowThisWeekTodos:()->
        false
    thisWeekTodos:()->
        today = this
        queryReminders =
            duetime:{
                $gte: today.clone().toDate()
                $lt: today.clone().add(1,"days").toDate()
            }
            type : 3
        todos = Todos.find(queryReminders,{sort:{duetime:1}})
        todos
