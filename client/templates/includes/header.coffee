Template.header.events
    'click #btnSearch': () ->
        searchTag = $("#quickTag").val()
        if searchTag.length > 0
            window.location.href = "/search/" + searchTag
    # 'change [name=appSelection]':(e,t)->
    #     data = t.data
    #     appSelected = $('[name=appSelection]').val()
    #     if appSelected of DefaultConfigure.exams
    #         Router.go('examCal',{_exam:appSelected},{query:$.param(data)})
    #     if appSelected of DefaultConfigure.otherApps
    #         switch appSelected
    #             when 'todo'
    #                 Router.go('todoWeekly')
    #     null
    'blur #pageTitle':(e,t)->
        pageTitle = $("#pageTitle").val()
        if pageTitle
            document.title = pageTitle

        null

Template.header.helpers
    showStatisticsExam:()->
        if Roles.userIsInRole(Meteor.user(),"user",'statisticsExam')
            return true
        false

    showTodoMyCal:()->
        if Roles.userIsInRole(Meteor.user(),"user",'todoMyCal')
            return true
        false
    showPmCal:()->
        if Roles.userIsInRole(Meteor.user(),"admin",'pmCal')
            return true
        false
    examCals:()->
        _exam = this._exam
        apps = []
        for exam of DefaultConfigure.exams
            if exam is _exam
                apps.push {value:exam, exam:{_exam:exam}, isSelected: true, words: DefaultConfigure.exams[exam]}
            else
                apps.push {value:exam, exam:{_exam:exam}, isSelected: false, words: DefaultConfigure.exams[exam]}
        # for app of DefaultConfigure.otherApps
        #     apps.push {value:app, isSelected: false, words: DefaultConfigure.otherApps[app]}

        apps
    _exam:()->
        if '_exam' of this
            return {_exam:DefaultConfigure.exams[this._exam]}
        else
            return false
    data:()->
        {_exam:this._exam}
