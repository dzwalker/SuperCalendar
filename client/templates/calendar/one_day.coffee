Template.oneDay.helpers
    cssToday:()->
        if this.isSame(moment(0,"hh"), 'day')
            return "cssToday"
        null
    queryTeachersSubjects:()->
        queryTeachersSubjects = {}
        if "teachers" of this
            queryTeachersSubjects["teachers"] =
                teachers : {$elemMatch : {$in : this.teachers}}
        # if "subjects" of this
        #     queryTeachersSubjects[subject] =
        #         subject : {$elemMatch : {$in : this.teachers}}
        # Template.registerHelper("queryTeachersSubjects",()->queryTeachersSubjects)
        queryTeachersSubjects
    queryString:()->
        query = {date:this.format("YYYYMMDD")}
        _.extend(query,Template.parentData(4).data.query)
        $.param(query)
    dateString:()->
        this.format("YYYYMMDD")
    date:()->

        this.format("MM/DD")
    activities:()->
        if Session.get("viewActivities") is 1
            today = this
            queryTeachers = Template.parentData(4).data.queryTeachers
            querySubjects = Template.parentData(4).data.querySubjects
            queryActivities =
                duetime:{
                    $gte: today.clone().toDate()
                    $lt: today.clone().add(1,"days").toDate()
                }
            queryExam = Session.get("_exam")
            if queryExam isnt 'all'
                _.extend(queryActivities,{exam : queryExam})
            _.extend(queryActivities,queryTeachers)
            return Activities.find(queryActivities,{sort:{duetime:1}})
        null
    todoEvents:()->
        today = this
        queryTodoEvents =
            duetime:{
                $gte: today.clone().toDate()
                $lt: today.clone().add(1,"days").toDate()
            }
            type : 7
        queryExam = Session.get("_exam")
        if queryExam isnt 'all'
            _.extend(queryTodoEvents,{userId : queryExam})
        todos = Todos.find(queryTodoEvents,{sort:{duetime:1}})
        todos

    courses:()->
        if Session.get("viewCourses") is 1
            today = this
            queryTeachers = Template.parentData(4).data.queryTeachers
            querySubjects = Template.parentData(4).data.querySubjects
            queryCourseTypes = Template.parentData(4).data.queryCourseTypes
            queryCourse =
                dateBegin:{
                    $gte: today.clone().toDate()
                    $lt: today.clone().add(1,"days").toDate()
                }
            queryExam = Session.get("_exam")
            if queryExam isnt 'all'
                _.extend(queryCourse,{exam : queryExam})
            _.extend(queryCourse,queryTeachers,querySubjects,queryCourseTypes)
            # console.log 'queryCourse',queryCourse
            # console.log  Courses.find(queryCourse,{sort:{dateBegin:1}})
            return Courses.find(queryCourse,{sort:{dateBegin:1}})
        null

    liveCourses:()->
        if Session.get("viewCourses") is 2
            todayString = this.format("YYYYMMDD")
            queryTeachers = Template.parentData(4).data.queryTeachers
            querySubjects = Template.parentData(4).data.querySubjects
            queryCourseTypes = Template.parentData(4).data.queryCourseTypes
            queryLiveCourses = {
                liveDates:{$in : [todayString]}
            }
            queryExam = Session.get("_exam")
            if queryExam isnt 'all'
                _.extend(queryLiveCourses,{exam : queryExam})
            _.extend(queryLiveCourses,queryTeachers,querySubjects,queryCourseTypes)
            liveCoursesCursor = Courses.find(queryLiveCourses,{sort:{dateBegin:1}})
            liveCourses = []
            hasConflict = false
            liveCoursesConflictCheck = {}
            liveCoursesCursor.forEach((doc)->
                for i in [0...doc.liveDates.length]
                    if todayString is doc.liveDates[i]
                        oneLiveCourse = {liveIndex:i}
                        (_.extend(oneLiveCourse,doc ))
                        oneLiveCourse._id += "-" + i
                        liveCourses.push oneLiveCourse
                        if not hasConflict
                            for t in oneLiveCourse.teachers
                                if t not of liveCoursesConflictCheck
                                    liveCoursesConflictCheck[t] = []
                                liveTimeInt = oneLiveCourse.liveTimes
                                if "specialLiveTime" of oneLiveCourse
                                    if oneLiveCourse.specialLiveTime[i]>0
                                        liveTimeInt = oneLiveCourse.specialLiveTime[i]
                                for timeInt in liveCoursesConflictCheck[t]
                                    if Math.abs(liveTimeInt - timeInt)<200
                                        hasConflict = true
                                liveCoursesConflictCheck[t].push liveTimeInt
            )
            # console.log todayString,"::::",hasConflict,liveCoursesConflictCheck
            cssHasConflict = ""
            if hasConflict
                cssHasConflict = "cssHasConflict"
                console.log liveCourses
            return {liveCourses:liveCourses, cssHasConflict:cssHasConflict}
        null
    _exam:()->
        queryExam = Session.get("_exam")
        {_exam:queryExam}
    isShowEvent:()->
        exam = Session.get("_exam")
        if exam isnt 'all'
            return true
        false
    isShowExamAction:()->
        exam = Session.get("_exam")
        if exam is 'all'
            return false
        else
            if Roles.userIsInRole(Meteor.user(),'admin', exam)
                return true
            else
                return false
        null
