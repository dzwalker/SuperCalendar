Template.todoItem.onRendered(
    ()->
        queryData = this.data.query
        oriType = this.data.thisItem.type
        if oriType isnt 1
            $("#divTimeInput").addClass("hidden")
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
            else if Roles.userIsInRole(Meteor.userId(), 'admin', 'todo')
                todoSettings = Settings.findOne({name:"todo"}).value
                owner = Meteor.users.findOne({_id:this.thisItem.userId}).username
                currentUser = Meteor.users.findOne({_id:Meteor.userId()})
                adminedUsersNames = todoSettings.admin[currentUser.username]
                if owner in adminedUsersNames
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
        if thisTodo.catagory
            titleShow = "【#{thisTodo.catagory}】#{thisTodo.title}"
        else
            titleShow = thisTodo.title

        _.extend(thisTodo,{titleShow:titleShow})
        thisTodo
    dueDate: ()->
        moment(this.thisItem.duetime).format("YYYY/MM/DD")

    todoId:()->
        this.thisItem._id

    defaultTime:()->
        outTime = moment()
        if this.thisItem.type is 1
            outTime = moment(this.thisItem.duetime)
        outTime.format("HH:mm")

    defaultTypesCheck:()->
        type1Text = false
        type2Text = false
        type3Text = false
        type4Text = false
        switch this.thisItem.type
            when 1
                type1Text = true
            when 2
                type2Text = true
            when 3
                type3Text = true
            when 4
                type4Text = true
        {type1Text:type1Text,type2Text:type2Text,type3Text:type3Text,type4Text:type4Text}
    duration:()->
        duration = 0
        if "duration" of this.thisItem
            duration = this.thisItem.duration
        duration
Template.todoItem.events
    'change input[name=type]':(e,t)->
        currentType = $("input[name=type]:checked").val()
        if currentType is "1"
            $("#divTimeInput").removeClass("hidden")
        else
            $("#divTimeInput").addClass("hidden")

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
                timeStr = $(e.target).find('[name=time]').val()
                # hour = parseInt($(e.target).find('[name=hour]').val())
                hour = timeStr.split(":")[0]
                duetime.hour(hour)
                # minute = parseInt($(e.target).find('[name=minute]').val())
                minute = timeStr.split(":")[1]
                duetime.minute(minute)
                duetime.second(0)
                duration = parseFloat($(e.target).find('[name=duration]').val())
                if duration > 0
                    _.extend(updateProperties,{duration:duration})
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
