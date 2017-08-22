Template.pmCalOneDay.helpers
    cssByTime:()->
        if this.isSame(moment(0,"hh"), 'day')
            return "cssToday"
        else if this.isBefore(moment(0,"hh"))
            return 'cssBeforeToday'
        null

    queryString:()->
        query = {deadline:this.format("YYYYMMDD")}
        # console.log Template.parentData(4).data
        _.extend(query,Template.parentData(4).data.query)
        $.param(query)
    # dateString:()->
    #     this.format("YYYYMMDD")
    date:()->
        this.format("MM/DD")
    thisDayDeadlineProjects:()->
        today = this
        queryProjects =
            deadline:{
                $gte: today.clone().toDate()
                $lt: today.clone().add(1,"days").toDate()
            }
        if Session.get("viewCompleted") is 0
            _.extend(queryProjects,{status:{$ne:1}})
        projects = Projects.find(queryProjects,{sort:{submitted:1}})
        projects

    thisDayCheckPoints:()->
        today = this
        queryCheckpoints =
            date:{
                $gte: today.clone().toDate()
                $lt: today.clone().add(1,"days").toDate()
            }
        if Session.get("viewCompleted") is 0
            _.extend(queryCheckpoints,{status:{$ne:1}})
        checkpoints = ProjectCheckpoints.find(queryCheckpoints,{sort:{submitted:1}})
        checkpoints
