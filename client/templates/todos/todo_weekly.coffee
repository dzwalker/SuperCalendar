Template.todoWeekly.onRendered(
    ()->
        queryData = this.data.query
        this.$('.datepicker').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1
            autoclose: true
            }).on('changeDate',(e)->
                queryData["startDate"] = e.format()
                Router.go('todoWeekly',{},{query:$.param(queryData)})
                )
)

Template.todoWeekly.onCreated(
    ()->
        Session.set("todoViewMode",1)
        queryData = this.data.query
        uid = Meteor.userId()
        if 'uid' of queryData
            if Roles.userIsInRole(Meteor.user(),'admin', 'todo')
                uid = queryData['uid']
        Session.set("todoUserId",uid)
        null
)


Template.todoWeekly.helpers
    dateString:()->
        if 'startDate' of this.query
            startDate = moment(this.query.startDate,"YYYYMMDD")
            startDate.startOf('isoweek')
            startDate.day(1)
        else
            startDate = moment(0,"hh")
            startDate.startOf('isoweek')
            startDate.day(1)
        # endDate = startDate.clone().add(6,"days")
        startDate.format("YYYY/MM/DD")
    dateStringPreWeek:()->
        queryData = this.query
        if 'startDate' of queryData
            startDate = moment(queryData.startDate,"YYYYMMDD")
            startDate.startOf('isoweek')
            startDate.day(1)
        else
            startDate = moment(0,"hh")
            startDate.startOf('isoweek')
            startDate.day(1)
        preWeek = startDate.clone().add(-7,'days')
        query = {}
        _.extend(query,queryData)
        query['startDate'] = preWeek.format("YYYYMMDD")
        $.param(query)
    dateStringNextWeek:()->
        queryData = this.query
        if 'startDate' of queryData
            startDate = moment(queryData.startDate,"YYYYMMDD")
            startDate.startOf('isoweek')
            startDate.day(1)
        else
            startDate = moment(0,"hh")
            startDate.startOf('isoweek')
            startDate.day(1)
        nextWeek = startDate.clone().add(7,'days')
        query = {}
        _.extend(query,queryData)
        query['startDate'] = nextWeek.format("YYYYMMDD")
        $.param(query)
    todoWeeklyContentData:()->
        queryData = this.query

        if 'startDate' of this.query
            startDate = moment(this.query.startDate,"YYYYMMDD")
            startDate.startOf('isoweek')
            startDate.day(1)
        else
            startDate = moment(0,"hh")
            startDate.startOf('isoweek')
            startDate.day(1)
        endDate = startDate.clone().add(6,"days")
        dateString = {startDate:startDate.format("YYYYMMDD"),startDateString:startDate.format("MM月DD日"),endDateString:endDate.format("MM月DD日")}
        isEditableMode = Session.get("todoViewMode")
        queryUserComment =
            duetime:{
                $gte: startDate.clone().toDate()
                $lt: startDate.clone().add(7,"days").toDate()
            }
            userId:Session.get('todoUserId')
            type: 8
        userComment = Todos.findOne(queryUserComment)
        # console.log weeklySummary
        if not userComment
            console.log 'userComment undefined'
            duetime = startDate.clone()
            duetime.hour(23)
            duetime.minute(59)
            duetime.second(59)
            duetime.millisecond(0)
            duetime.startOf('isoweek')
            duetime.day(7)
            title = "客户心声"
            type = 8
            catagory = "客户心声"
            userId = Session.get("todoUserId")
            todo =
                userId : userId
                duetime : duetime.toDate()
                title : title
                type : type
                catagory : catagory
                note : ""

            Meteor.call('todoInsert',todo, (error,result)->
                if error
                    return alert(error.reason)
            	# Router.go('eventPage',{_id: result._id})
                else
                    # _.extend(result,{noteHtml:'1111'})
                    # _.extend(result,{noteHtml:result.note.replaceAll('\\n','<br/>')})
                    userComment = Todos.findOne({_id:result})
                    # Router.go('todoWeekly',{},{query:$.param(queryData)})

            )
        else
            _.extend(userComment,{noteHtml:userComment.note.replace(/\n/g,'<br>')})

        querySummary =
            duetime:{
                $gte: startDate.clone().toDate()
                $lt: startDate.clone().add(7,"days").toDate()
            }
            userId:Session.get('todoUserId')
            type: 6
        weeklySummary = Todos.findOne(querySummary)
        # console.log weeklySummary
        if not weeklySummary
            console.log 'weeklySummary undefined'
            duetime = startDate.clone()
            duetime.hour(23)
            duetime.minute(59)
            duetime.second(59)
            duetime.millisecond(0)
            duetime.startOf('isoweek')
            duetime.day(7)
            title = "评价与总结"
            type = 6
            catagory = "评价与总结"
            userId = Session.get("todoUserId")
            todo =
                userId : userId
                duetime : duetime.toDate()
                title : title
                type : type
                catagory : catagory
                note : ""

            Meteor.call('todoInsert',todo, (error,result)->
                if error
                    return alert(error.reason)
            	# Router.go('eventPage',{_id: result._id})
                else
                    # _.extend(result,{noteHtml:'1111'})
                    # _.extend(result,{noteHtml:result.note.replaceAll('\\n','<br/>')})
                    weeklySummary = Todos.findOne({_id:result})
                    # Router.go('todoWeekly',{},{query:$.param(queryData)})

            )
        else
            _.extend(weeklySummary,{noteHtml:weeklySummary.note.replace(/\n/g,'<br>')})

        queryTodo =
            duetime:{
                $gte: startDate.clone().toDate()
                $lt: startDate.clone().add(7,"days").toDate()
            }
            userId:Session.get('todoUserId')
            type: 5
        todosCursor = Todos.find(queryTodo)
        tree = {}
        catagories = Meteor.users.findOne({_id:Session.get('todoUserId')}).todoCatagories
        if not catagories
            Router.go('todoMySettings')

        for catagory in catagories
            tree[catagory] = []
        todosCursor.forEach((doc)->
            if doc.catagory not of tree
                tree[doc.catagory] = []
            _.extend(doc,isEditableMode:isEditableMode)
            _.extend(doc,{noteHtml:doc.note.replace(/\n/g,'<br>')})

            tree[doc.catagory].push doc
            )
        treeArray = []
        for catagory of tree
            treeArray.push {catagory: catagory,todos:tree[catagory],isEditableMode:isEditableMode}
        todoTree = treeArray
        {dateString:dateString,isEditableMode:isEditableMode,weeklySummary:weeklySummary,userComment:userComment,todoTree:todoTree}


    todoUsers:()->
        if Roles.userIsInRole(Meteor.user(),"admin",'todo')
            todoSettings = Settings.findOne({name:"todo"}).value
            currentUser = Meteor.users.findOne({_id:Meteor.userId()})
            usersNames = todoSettings.admin[currentUser.username]
            usersAdmined = Meteor.users.find({username:{$in:usersNames}})
            # usersAdmined = []
            return usersAdmined
        else
            return null

        # Meteor.users.find({todoCatagories:{$exists:true}})


Template.todoWeekly.events
    'submit form': (e,t) ->
        e.preventDefault()
        query = t.data.query
        if 'startDate' of query
            startDate = moment(query.startDate,"YYYYMMDD")
            startDate.startOf('isoweek')
            startDate.day(1)
        else
            startDate = moment(0,"hh")
            startDate.startOf('isoweek')
            startDate.day(1)
        # console.log $('.datepicker').datepicker('getDate')
        # console.log t
        duetime = startDate.clone()
        # console.log duetime
        duetime.hour(23)
        duetime.minute(59)
        duetime.second(59)
        duetime.millisecond(0)
        duetime.startOf('isoweek')
        duetime.day(7)
        title = $(e.target).find('[name=title]').val()
        # type = parseInt($(e.target).find('[name=type]').val())
        catagory = $(e.target).find('[name=catagory]').val()
        title ?= ""
        userId = Session.get("todoUserId")
        todo =
            userId : userId
            duetime : duetime.toDate()
            title : title
            type : 5
            catagory : catagory

        Meteor.call('todoInsert',todo, (error,result)->
            if error
                return alert(error.reason)
        	# Router.go('eventPage',{_id: result._id})
            else
                $("[name=title]").val("")

                # FlashMessages.sendSuccess("你创建了一个任务！")
        )
        null
    'click a.starIt':(e,t)->
        console.log e
        Meteor.call('todoStarIt',e.currentTarget.getAttribute("data-todoId"), (error,result)->
            if error
                return alert(error.reason)
            else
                console.log 'star it!'
            )
        null
    'click a.unstarIt':(e,t)->
        # console.log e
        Meteor.call('todoUnstarIt',e.currentTarget.getAttribute("data-todoId"), (error,result)->
            if error
                return alert(error.reason)
            else
                console.log 'unstar it!'
            )
        null
    'click a.delIt':(e,t)->
        # console.log e
        # console.log e.currentTarget.getAttribute("data-todoId")
        Meteor.call('todoDelIt',e.currentTarget.getAttribute("data-todoId"), (error,result)->
            if error
                return alert(error.reason)
            else
                console.log 'del it!'
            )
    'change [name=viewMode]':(e)->
        viewActivities = $('[name=viewMode]:checked').val()
        if viewActivities is "1"
            Session.set("todoViewMode",1)
        else if viewActivities is "0"
            # $('.oneDayActivities').hide()
            Session.set("todoViewMode",0)
        null

    'change [name=todoUsers]':(e,t)->
        # data = t.data.query
        uid = $('[name=todoUsers]').val()
        # _.extend(data,{uid:uid})
        # console.log data
        Session.set("todoUserId",uid)
        # Router.go('todoWeekly',{},{query:$.param(data)})
        null
    'click #sendTodoWeekly':(e,t)->
        # mail =
        # {
        #   to: 'Name <zhao@kmf.com>'
        #   subject: 'Subject'
        #   template: 'todoWeeklyContent'
        #   replyTo: 'Name <name@domain.com>'
        #   from: 'Name <name@domain.com>'
        #   cc: 'Name <name@domain.com>'
        #   bcc: 'Name <name@domain.com>'
        #   data: {}
        #   attachments: []
        # }
        # Mailer.send(mail)
        html=Blaze.toHTMLWithData(Template.todoWeeklyContent,{})
        console.log html
        null
