Template.selectorPersonal.onCreated(
    ()->


        null
)

Template.selectorPersonal.onRendered(
    ()->
        queryData = this.data.query
        this.$('.datepicker').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1
            autoclose: true

            }).on('changeDate',(e)->
                queryData["startDate"] = e.format()
                Router.go('selectorPersonal',{query:$.param(queryData)})
                )
)

Template.selectorPersonal.events
    'change [name=weeks]':(e,t)->
        queryData = t.data.query
        weeks = parseInt($('[name=weeks]').val())
        queryData["weeks"] = weeks
        Router.go('examCal',{_exam:Session.get("_exam")},{query:$.param(queryData)})
        null
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
        Router.go('examCal',{_exam:Session.get("_exam")},{query:$.param(queryData)})
        # Router.go('examCal',{_exam:exam},{query:$.param(data)})
        null

    'change [name=subjects]':(e,t)->

        queryData = t.data.query
        # result = $.param(data);
        subjects = []
        $.each($('[name=subjects]:checked'),()->
            subjects.push $(this).val()
        )
        queryData["subjects"] = subjects
        Router.go('examCal',{_exam:Session.get("_exam")},{query:$.param(queryData)})

        null

    'change [name=viewActivities]':(e)->
        viewActivities = $('[name=viewActivities]:checked').val()
        if viewActivities is "1"
            # $('.oneDayActivities').show()
            Session.set("viewActivities",1)
        else if viewActivities is "0"
            # $('.oneDayActivities').hide()
            Session.set("viewActivities",0)
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

    eventTypes:()->
        formEventTypes = []
        eventTypesIndex = Settings.findOne({name:'configureIndex'}).value.eventTypes.personal
        eventTypes = Settings.findOne({name:'eventTypes'}).value
        # console.log eventTypesIndex,eventTypes
        for e in eventTypesIndex
            formEventTypes.push {t:e, n:eventTypes[e]}
        formEventTypes
    subjects:()->
        exam = Session.get("_exam")
        if 'subjects' of this.query
            subjectsSelected = this.query.subjects
        else
            subjectsSelected = []
        FormOption.examSubjects(exam, subjectsSelected)
