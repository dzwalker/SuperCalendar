Template.todoMyCalOneTodo.helpers
    title:()->
        titleStr = ''
        if this.type is 1
            duetime = moment(this.duetime)
            titleStr += '['+ duetime.format("HH:mm")
            if "duration" of this
                if this.duration > 0
                    endTime = duetime.add(this.duration,'hour')
                    titleStr += '-' + endTime.format("HH:mm")

            titleStr += ']'
        titleStr += this.title
        titleStr
    cssStyle:()->
        reminderOrTodo = "badge-todo"
        if this.type is 1
            reminderOrTodo = "badge-reminder"
        if this.status is 1
            reminderOrTodo += " todo-completed"
        reminderOrTodo
    _id:()->
        this._id
