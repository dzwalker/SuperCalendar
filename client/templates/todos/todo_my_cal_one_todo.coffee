Template.todoMyCalOneTodo.helpers
    title:()->
        titleStr = ''
        if this.type is 1
            duetime = moment(this.duetime)
            titleStr += '['+ duetime.format("hh:mm") + ']'
        titleStr += this.title
        titleStr
    cssStyle:()->
        reminderOrTodo = "badge-todo"
        if this.type is 1
            reminderOrTodo = "badge-reminder"
        reminderOrTodo
    _id:()->
        this._id
