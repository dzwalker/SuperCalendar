Template.statisticsExamSelector.onCreated(
    ()->
        null
)

Template.statisticsExamSelector.onRendered(
    ()->
        queryData = this.data.query
        this.$('#startDate').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1
            autoclose: true
            }).on('changeDate',(e)->
                queryData["startDate"] = e.format()
                Router.go('statisticsExam',{_exam : Session.get("_exam")},{query:$.param(queryData)})
            )
        this.$('#endDate').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1
            autoclose: true
            }).on('changeDate',(e)->
                queryData["endDate"] = e.format()
                Router.go('statisticsExam',{_exam : Session.get("_exam")},{query:$.param(queryData)})
            )

)

Template.statisticsExamSelector.events

    'change [name=teachers]':(e,t)->
        # console.log "t",t
        queryData = t.data.query
        teachers = []
        $.each($('[name=teachers]:checked'),()->
            teachers.push $(this).val()
        )
        queryData["teachers"] = teachers
        # FlashMessages.sendSuccess("换了一下参数")
        # console.log "t.data._exam",t.data._exam
        Router.go('statisticsExam',{_exam:Session.get("_exam")},{query:$.param(queryData)})
        # Router.go('statisticsExam',{_exam:exam},{query:$.param(data)})
        null

    'change [name=subjects]':(e,t)->

        queryData = t.data.query
        # result = $.param(data);
        subjects = []
        $.each($('[name=subjects]:checked'),()->
            subjects.push $(this).val()
        )
        queryData["subjects"] = subjects
        Router.go('statisticsExam',{_exam:Session.get("_exam")},{query:$.param(queryData)})

        null
    'change [name=courseTypes]':(e,t)->

        queryData = t.data.query

        courseTypes = $('[name=courseTypes]:checked').val()
        queryData["courseTypes"] = courseTypes
        Router.go('statisticsExam',{_exam:Session.get("_exam")},{query:$.param(queryData)})

        null


    'change [name=viewCourses]':(e)->
        viewCourses = $('[name=viewCourses]:checked').val()
        switch viewCourses
            when "1"
                $('.oneDayCourses').show()
                $('.oneDayLiveCourses').hide()
                Session.set("viewCourses",1)
            when "2"
                $('.oneDayLiveCourses').show()
                $('.oneDayCourses').hide()
                Session.set("viewCourses",2)
            when "0"
                $('.oneDayCourses').hide()
                $('.oneDayLiveCourses').hide()
                Session.set("viewCourses",0)
        null

Template.statisticsExamSelector.helpers
    startDate:()->
        if 'startDate' of this.query
            startDate = moment(this.query.startDate,"YYYYMMDD")
            # startDate.startOf('isoweek')

        else
            startDate = moment(0,"hh")
            # startDate.startOf('isoweek')
        startDate.format("YYYY/MM/DD")
    endDate:()->
        if 'endDate' of this.query
            endDate = moment(this.query.endDate,"YYYYMMDD")
            # endDate.startOf('isoweek')

        else
            endDate = moment(0,"hh")
            # endDate.startOf('isoweek')
            endDate.add('days',90)
        endDate.format("YYYY/MM/DD")
    isShowSubjectsCourseType:()->
        exam = Session.get("_exam")
        if exam is 'all'
            return false
        else
            return true
    formTeachers:()->
        exam = Session.get("_exam")
        if 'teachers' of this.query
            teachersSelected = this.query.teachers
        else
            teachersSelected = []
        nameType = "nickName"
        FormOption.teachers(exam, nameType, teachersSelected)
    formCourseTypes:()->
        exam = Session.get("_exam")
        if 'courseTypes' of this.query
            courseTypesSelected = this.query.courseTypes
        else
            courseTypesSelected = []
        FormOption.courseTypes(exam, courseTypesSelected)
    subjects:()->
        exam = Session.get("_exam")
        if 'subjects' of this.query
            subjectsSelected = this.query.subjects
        else
            subjectsSelected = []
        FormOption.examSubjects(exam, subjectsSelected)
