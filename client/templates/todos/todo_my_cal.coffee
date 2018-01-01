Template.todoMyCal.onRendered(
    ()->
        $('#itemsSelectors').stickUp()
        null
)

Template.todoMyCal.onCreated(
    ()->

        if not Meteor.Device.isDesktop()
            Router.go('todoMyCalMobile')
        null
)


Template.todoMyCal.helpers
    weeksAndQuery:()->
        query = this.query
        if 'startDate' of this.query
            startDate = moment(this.query.startDate,"YYYYMMDD")
            startDate.startOf('isoweek')
            startDate.day(1)
        else
            startDate = moment(0,"hh")
            startDate.startOf('isoweek')
            startDate.day(1)
            # .day(0)
        if 'weeks' of this.query
            numberOfWeeks = this.query.weeks
        else
            numberOfWeeks = 1
        weeks = []
        for w in [0...numberOfWeeks] by 1
            thisWeek = []
            for d in [0...7] by 1
                thisWeek[d] = startDate.clone()
                thisWeek[d].add(w*7+d,'days')
            weeks.push thisWeek
        return {weeks : weeks, query:query, app:"todoMyCal"}
