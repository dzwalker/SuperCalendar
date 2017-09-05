Template.todoItem.onRendered(
    ()->
        queryData = this.data.query
        this.$('.datepicker').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1
            autoclose: true
            })
)

Template.todoItem.helpers
    isEditable:()->
        if this.thisItem.type is 7
            if Roles.userIsInRole(Meteor.userId(),this.userId, 'admin')
                return true
        else if this.thisItem.type in [1,2,3]
            if Meteor.userId() is this.thisItem.userId
                return true
        false
    isPersonalTodo:()->
        if this.thisItem.type is 7
            return false
        true
    todoIsChecked:()->
        todoIsChecked = false
        if this.thisItem.status is 1
            todoIsChecked = true
        todoIsChecked
    thisTodo:()->
        thisTodo = this.thisItem
        teachers = []
        titleShow = "【#{thisTodo.catagory}】#{thisTodo.title}"
        _.extend(thisTodo,{titleShow:titleShow})
        thisTodo
    dueDate: ()->
        moment(this.thisItem.duetime).format("YYYY/MM/DD")

    todoId:()->
        this.thisItem._id

Template.todoItem.events
    'submit form': (e,t) ->
        e.preventDefault()
        todoId = $(e.target).find('[name=todoId]').val()
        isPersonalTodo = parseInt $(e.target).find('[name=isPersonalTodo]').val()
        title = $(e.target).find('[name=title]').val()

        title ?= ""
        note = $(e.target).find('[name=note]').val()
        note ?= ""
        updateProperties =
            title : title
            note : note
        if isPersonalTodo
            todoType = parseInt $(e.target).find('[name=type]:checked').val()
            duetime = moment $(e.target).find('[name=dueDate]').val()
            duetime.millisecond(0)

            if todoType is 1
                hour = parseInt($(e.target).find('[name=hour]').val())
                duetime.hour(hour)
                minute = parseInt($(e.target).find('[name=minute]').val())
                duetime.minute(minute)
                duetime.second(0)
            else
                duetime.hour(23)
                duetime.minute(59)
                duetime.second(59)
            _.extend(updateProperties,{duetime:duetime.toDate(),type:todoType})
        else
            exam = $(e.target).find('[name=exam]').val()
            query = t.data.query

        Meteor.call('todoUpdate',todoId,updateProperties, (error,result)->
            if error
                return alert(error.reason)
        	# Router.go('eventPage',{_id: result._id})
            else
                FlashMessages.sendSuccess("你更新了这个TODO！")
                if not isPersonalTodo
                    Router.go('examCal',{_exam:exam},{query:$.param(query)})
        )
        null
    'click .todoChangeStatus':(e,t)->
        todoId = e.currentTarget.getAttribute("data-todoId")
        status = parseInt(e.currentTarget.getAttribute("data-status"))
        updateProperties = {status: status}
        Meteor.call('todoUpdate',todoId,updateProperties, (error,result)->
            if error
                return alert(error.reason)
            else
                console.log 'updateProperties: status!'
            )
        null
