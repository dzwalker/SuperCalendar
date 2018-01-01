Template.todoMyCalMobile.onRendered(
    ()->
        uid = Session.get("todoUserId")
        if not uid
            uid = Meteor.userId()
            Session.set("todoUserId",uid)
        query = this.data.query
        if 'date' of query
            dateSelected = moment(query.date,"YYYYMMDD")
        else
            dateSelected = moment(0,"hh")
        Session.set("dateSelected",dateSelected.toDate())

        todayId = "#"+moment(0,'h').format("YYYYMMDD")
        $(todayId).addClass("cssToday")
        null
)

Template.todoMyCalMobile.onCreated(
    ()->

        null
)


Template.todoMyCalMobile.helpers
    weeksOfMonthTable:()->
        # today = moment(0,'h')
        if 'date' of this.query
            dateSelected = moment(this.query.date,"YYYYMMDD")
        else
            dateSelected = moment(0,"hh")
        mondayOfThisWeek = dateSelected.clone().day(1)
        weeks = []
        for w in [0]
            oneWeek = []
            for d in [0...7]
                thisDay = mondayOfThisWeek.clone().add(w*7+d,'days')
                todoUserId = Session.get("todoUserId")
                queryReminders =
                    userId : todoUserId
                    duetime:{
                        $gte: thisDay.clone().toDate()
                        $lt: thisDay.clone().add(1,"days").toDate()
                    }
                    status:{$ne:1}
                    type:{$in:[1,2]}

                countDeadline = Todos.find(queryReminders).count()
                if countDeadline is 0
                    countDeadline = "&nbsp;"
                oneWeek.push {dateStr:thisDay.format("D"),countDeadline:countDeadline,date:thisDay.format("YYYYMMDD")}
            weeks.push {oneWeek:oneWeek}
        weeks
    thisDayDeadlineTodos:()->
        dateSelected = moment(Session.get("dateSelected"))
        todoUserId = Session.get("todoUserId")
        queryReminders =
            userId : todoUserId
            duetime:{
                $gte: dateSelected.clone().toDate()
                $lt: dateSelected.clone().add(1,"days").toDate()
            }
            type:{$in:[1,2]}
        if Session.get("viewCompleted") is 0
            _.extend(queryReminders,{status:{$ne:1}})
        todos = Todos.find(queryReminders,{sort:{duetime:1}})
        todos
    dateSelected:()->
        moment(Session.get("dateSelected")).format("M月D日")

    queryString:()->
        query = {deadline:moment(Session.get("dateSelected")).format("YYYYMMDD")}
        $.param(query)
    dateStringPreWeek:()->
        query = this.query
        if 'date' of query
            dateSelected = moment(query.date,"YYYYMMDD")
        else
            dateSelected = moment(0,"hh")

        newQuery = {date:dateSelected.add(-1,'week').format("YYYYMMDD")}
        $.param(newQuery)

    dateStringNextWeek:()->
        query = this.query
        if 'date' of query
            dateSelected = moment(query.date,"YYYYMMDD")
        else
            dateSelected = moment(0,"hh")
        newQuery = {date:dateSelected.add(1,'week').format("YYYYMMDD")}
        $.param(newQuery)


Template.todoMyCalMobile.events
    'click .oneDayCell':(e,t)->
        dateString = e.currentTarget.getAttribute("data-date")
        Session.set("dateSelected",moment(dateString,'YYYYMMDD').toDate())
        $(".cssToday").removeClass("cssToday")
        $("#"+dateString).addClass("cssToday")

        null
