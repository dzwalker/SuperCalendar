# TODO: 活动也加上直播时间



Template.superCalendar.onRendered(
    ()->
        $('#itemsSelectors').stickUp()
        # Session.set('pageTitle','活动与课程')
        # document.title = "活动与课程"
        null
)

Template.superCalendar.onCreated(
    ()->

        # document.title = Session.get('_exam')
        null
)


Template.superCalendar.helpers
    weeksAndQuery:()->
        # console.log "session:",Session.get("_exam")
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
        if 'courseTypes' of this.query
            queryCourseTypes = {type: {$in : this.query.courseTypes}}
        else
            queryCourseTypes = null
        if "subjects" of this.query
            querySubjects = {subject: {$in : this.query.subjects}}
        else
            querySubjects =  null
        return {app:"examCal",weeks : weeks, queryTeachers : queryTeachers, querySubjects:querySubjects,queryCourseTypes:queryCourseTypes, queryExam:this._exam, query:query}
