Template.selectorPersonal.onCreated(
    ()->
        uid = Session.get("todoUserId")
        if not uid
            uid = Meteor.userId()
            Session.set("todoUserId",uid)
        queryData = this.data.query

        if 'uid' of queryData
            if Roles.userIsInRole(Meteor.user(),'admin', 'todo')
                uid = queryData['uid']
        Session.set("todoViewMode",0)
        null
)

Template.selectorPersonal.onRendered(
    ()->
        $("#changeUser").val(Session.get("todoUserId"))

        queryData = this.data.query
        this.$('.datepicker').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1
            autoclose: true

            }).on('changeDate',(e)->
                queryData["startDate"] = e.format("yyyymmdd")
                console.log queryData
                Router.go('todoMyCal',{},{query:$.param(queryData)})
                )
)

Template.selectorPersonal.events
    'change [name=todoUsers]':(e,t)->
        uid = $('[name=todoUsers]').val()
        Session.set("todoUserId",uid)
        null
    'change [name=viewCompleted]':(e)->
        viewCompleted = $('[name=viewCompleted]:checked').val()
        if viewCompleted is "1"
            Session.set("todoViewMode",1)
        else if viewCompleted is "0"
            # $('.oneDayActivities').hide()
            Session.set("todoViewMode",0)
        null


Template.selectorPersonal.helpers
    startDate:()->
        if 'startDate' of this.query
            startDate = moment(this.query.startDate,"YYYYMMDD")
            startDate.startOf('isoweek')
            startDate.day(1)
        else
            startDate = moment(0,"hh")
            startDate.startOf('isoweek')
            startDate.day(1)
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
