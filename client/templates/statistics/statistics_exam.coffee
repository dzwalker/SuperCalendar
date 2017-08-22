
Template.statisticsExam.onRendered(
    ()->
        $('#itemsSelectors').stickUp()
        null
)

Template.statisticsExam.onCreated(
    ()->

        # document.title = Session.get('_exam')
        null
)


Template.statisticsExam.helpers
    monthsAndQuery:()->
        # console.log "session:",Session.get("_exam")
        query = this.query
        if 'startDate' of this.query
            startDate = moment(this.query.startDate,"YYYYMMDD")
            # startDate.startOf('isoweek')
        else
            startDate = moment(0,"hh")
            # startDate.startOf('isoweek')
        if 'endDate' of this.query
            endDate = moment(this.query.endDate,"YYYYMMDD")
            # endDate.startOf('isoweek')
        else
            endDate = moment(0,"hh")
            # endDate.startOf('isoweek')
            endDate.add('days',90)

        dateByMonth = []
        dateByMonth.push startDate
        compareDate = startDate.clone()
        compareDate.add(1,'months')
        compareDate.date(1)
        while (compareDate < endDate)

            dateByMonth.push compareDate.clone()
            compareDate.add(1,'months')
        dateByMonth.push endDate
        if "teachers" of this.query
            teachers = this.query.teachers
            # queryTeachers ={teachers: {$elemMatch : {$in : this.query.teachers}}}
        else
            examTeachers = Settings.findOne({name:'configureIndex'}).value.teachers
            teachers = examTeachers[this._exam]
        if 'courseTypes' of this.query
            courseTypes = this.query.courseTypes
            # queryCourseTypes = {type: {$in : this.query.courseTypes}}
        else
            courseTypes = 'aio'
        if "subjects" of this.query
            subjects = this.query.subjects
            # querySubjects = {subject: {$in : this.query.subjects}}
        else
            examSubjects = Settings.findOne({name:'configureIndex'}).value.examSubjects
            subjects = examSubjects[this._exam]
        return {dateByMonth : dateByMonth,teachers : teachers, subjects:subjects,courseTypes:courseTypes, queryExam:this._exam, query:query}
