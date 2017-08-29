Template.activityItem.helpers
    roleExam:()->
        this._exam
    thisActivity:()->
        exam = this._exam
        thisActivity = Activities.findOne({_id:this._id})
        teachers = []
        settingTeachers = Settings.findOne({name:'teachers'}).value
        settingActivityTypes = Settings.findOne({name:'activityTypes'}).value

        for t in thisActivity.teachers
            teachers.push settingTeachers[t].shortName
        title = ""
        if thisActivity.status is 1
            title += "(待定)"
        title += "#{teachers.join()}：#{settingActivityTypes[thisActivity.type]}"
        if thisActivity.title isnt ''
            title += "-" + thisActivity.title
        thisActivity["titleShow"] = title
        if thisActivity.status is 0
            thisActivity["status0"] = true
            thisActivity["status1"] = false
        else
            thisActivity["status0"] = false
            thisActivity["status1"] = true
        thisActivity
    formTeachers:()->
        exam = this._exam
        thisActivity = Activities.findOne({_id:this._id})
        nameType = "nickName"
        FormOption.teachers(exam, nameType,thisActivity.teachers)

Template.activityItem.events
    'click .delActivity':(e,t)->
        activityID = e.currentTarget.getAttribute("data-ActivityId")
        Meteor.call('activityDelete',activityID,(error,result)->
            if error
                return alert(error.reason)
            else
                FlashMessages.sendError("你消灭了一个活动！")

        )
    'submit form': (e,t) ->
        e.preventDefault()
        activityID = $(e.target).find('[name=activityID]').val()
        exam = $(e.target).find('[name=exam]').val()
        title = $(e.target).find('[name=title]').val()
        title ?= ""
        note = $(e.target).find('[name=note]').val()
        note ?= ""
        status = parseInt($(e.target).find('[name=status]:checked').val())
        teachers = []
        $.each($(e.target).find('[name=teachers]:checked'),()->
            teachers.push $(this).val()
        )

        if teachers.length < 1
            alert '请选择老师!'
            return null

        updateProperties =
            title : title
            teachers : teachers
            status : status
            note : note
        # console.log activity
        query = t.data.query
        # if 'date' of query
        #     delete query.date
        Meteor.call('activityUpdate',activityID,updateProperties, (error,result)->
            if error
                return alert(error.reason)
        	# Router.go('eventPage',{_id: result._id})
            else
                FlashMessages.sendSuccess("你更新了这个活动！")
                Router.go('examCal',{_exam:exam},{query:$.param(query)})

                # Router.go('activityItem',{_exam:exam, _id: activityID})
        )
        null
