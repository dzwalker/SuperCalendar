Template.personalCalendar.onRendered(
    ()->
        $('#itemsSelectors').stickUp()
        null
)


Template.personalCalendar.helpers
    weeksAndQuery:()->
        # console.log "session:",Session.get("_exam")
        query = this.query
        if 'startDate' of this.query
            startDate = moment(this.query.startDate,"YYYYMMDD").day(0)
        else
            startDate = moment(0,"hh").day(0)
        if 'weeks' of this.query
            numberOfWeeks = this.query.weeks
        else
            numberOfWeeks = 6
        weeks = []
        for w in [0...numberOfWeeks] by 1
            thisWeek = []
            for d in [0...7] by 1
                thisWeek[d] = startDate.clone()
                thisWeek[d].add(w*7+d,'days')
                # thisWeek.push startDate.add(w*7+d,'days')
            weeks.push thisWeek
        # Meteor.subscribe 'activities', startDate, endDate
        if "teachers" of this.query
            queryTeachers ={teachers: {$elemMatch : {$in : this.query.teachers}}}
        else
            queryTeachers = null
        if "subjects" of this.query
            querySubjects = {subject: {$in : this.query.subjects}}
        else
            querySubjects =  null
        return {weeks : weeks, calendarType:"personal"}
