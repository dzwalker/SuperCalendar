Template.selectorPm.onCreated(
    ()->
        Session.set("viewCompleted",0)


        null
)

Template.selectorPm.onRendered(
    ()->
        queryData = this.data.query
        this.$('.datepicker').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1
            autoclose: true

            }).on('changeDate',(e)->
                queryData["startDate"] = e.format("yyyymmdd")
                Router.go('pmCal',{},{query:$.param(queryData)})
                )
)

Template.selectorPm.events

    'change [name=viewCompleted]':(e)->
        viewCompleted = $('[name=viewCompleted]:checked').val()
        if viewCompleted is "1"
            Session.set("viewCompleted",1)
        else if viewCompleted is "0"
            Session.set("viewCompleted",0)
        null

    'change [name=weeks]':(e,t)->
        queryData = t.data.query
        weeks = parseInt($('[name=weeks]').val())
        queryData["weeks"] = weeks
        Router.go('pmCal',{_exam:Session.get("_exam")},{query:$.param(queryData)})
        null
    'change [name=catagories]':(e,t)->
        # console.log "t",t
        queryData = t.data.query
        catagories = []
        $.each($('[name=catagories]:checked'),()->
            catagories.push $(this).val()
        )
        queryData["catagories"] = catagories
        # FlashMessages.sendSuccess("换了一下参数")
        # console.log "t.data._exam",t.data._exam
        Router.go('pmCal',{},{query:$.param(queryData)})
        # Router.go('examCal',{_exam:exam},{query:$.param(data)})
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

Template.selectorPm.helpers
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

    pmCatagories:()->
        if 'catagories' of this.query
            catagoriesSelected = this.query.catagories
        else
            catagoriesSelected = []
        FormOption.pmCatagories(catagoriesSelected)
