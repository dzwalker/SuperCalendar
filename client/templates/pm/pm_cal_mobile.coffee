Template.pmCalMobile.onRendered(
    ()->
        # query = this.query
        # if query
        # if 'date' of query
        #     dateSelected = moment(query.date,"YYYYMMDD")
        # else
        dateSelected = moment(0,"hh")
        Session.set("dateSelected",dateSelected.toDate())

        todayId = "#"+moment(0,'h').format("YYYYMMDD")
        $(todayId).addClass("cssToday")
        null
)

Template.pmCalMobile.onCreated(
    ()->

        null
)


Template.pmCalMobile.helpers
    weeksOfMonthTable:()->
        # today = moment(0,'h')
        if 'date' of this.query
            dateSelected = moment(this.query.date,"YYYYMMDD")
        else
            dateSelected = moment(0,"hh")
        firstDayOfTheMonth = dateSelected.clone().date(1)
        mondayOfFirstWeek = firstDayOfTheMonth.day(1)
        weeks = []
        for w in [0...6]
            oneWeek = []
            for d in [0...7]
                thisDay = mondayOfFirstWeek.clone().add(w*7+d,'days')
                queryProjects =
                    deadline:{
                        $gte: thisDay.clone().toDate()
                        $lt: thisDay.clone().add(1,"days").toDate()
                    }
                    status:{$ne:1}
                countDeadline = Projects.find(queryProjects).count()
                if countDeadline is 0
                    countDeadline = "&nbsp;"
                queryCheckpoints =
                    date:{
                        $gte: thisDay.clone().toDate()
                        $lt: thisDay.clone().add(1,"days").toDate()
                    }
                    status:{$ne:1}
                countCheckpoint = ProjectCheckpoints.find(queryCheckpoints).count()
                if countCheckpoint is 0
                    countCheckpoint = "&nbsp;"
                oneWeek.push {dateStr:thisDay.format("D"),countDeadline:countDeadline,countCheckpoint:countCheckpoint,date:thisDay.format("YYYYMMDD")}
            weeks.push {oneWeek:oneWeek}
        weeks
    thisDayDeadlineProjects:()->
        dateSelected = moment(Session.get("dateSelected"))
        queryProjects =
            deadline:{
                $gte: dateSelected.clone().toDate()
                $lt: dateSelected.clone().add(1,"days").toDate()
            }
        if Session.get("viewCompleted") is 0
            _.extend(queryProjects,{status:{$ne:1}})
        projects = Projects.find(queryProjects,{sort:{submitted:1}})
        projects
    dateSelected:()->

        moment(Session.get("dateSelected")).format("M月D日")
    dateMonth:()->
        query = this.query
        if 'date' of query
            dateSelected = moment(query.date,"YYYYMMDD")
        else
            dateSelected = moment(0,"hh")
        dateSelected.format("YY年M月")

    thisDayCheckPoints:()->
        dateSelected = moment(Session.get("dateSelected"))
        queryCheckpoints =
            date:{
                $gte: dateSelected.clone().toDate()
                $lt: dateSelected.clone().add(1,"days").toDate()
            }
        if Session.get("viewCompleted") is 0
            _.extend(queryCheckpoints,{status:{$ne:1}})
        checkpoints = ProjectCheckpoints.find(queryCheckpoints,{sort:{submitted:1}})
        checkpoints
    queryString:()->
        query = {deadline:moment(Session.get("dateSelected")).format("YYYYMMDD")}
        $.param(query)
    dateStringPreMonth:()->
        query = this.query
        if 'date' of query
            dateSelected = moment(query.date,"YYYYMMDD")
        else
            dateSelected = moment(0,"hh")

        newQuery = {date:dateSelected.add(-1,'month').format("YYYYMMDD")}
        $.param(newQuery)

    dateStringNextMonth:()->
        query = this.query
        if 'date' of query
            dateSelected = moment(query.date,"YYYYMMDD")
        else
            dateSelected = moment(0,"hh")
        newQuery = {date:dateSelected.add(1,'month').format("YYYYMMDD")}
        $.param(newQuery)


Template.pmCalMobile.events
    'click .oneDayCell':(e,t)->
        console.log '1'
        console.log e.currentTarget.getAttribute("data-date")
        dateString = e.currentTarget.getAttribute("data-date")
        Session.set("dateSelected",moment(dateString,'YYYYMMDD').toDate())
        $(".cssToday").removeClass("cssToday")
        $("#"+dateString).addClass("cssToday")

        null
