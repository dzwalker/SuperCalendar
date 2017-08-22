Template.settingCourse.onRendered(
    ()->
        options = {}
        containerType = document.getElementById("settingCourseTypeDiv")
        this["editorType"] = new JSONEditor(containerType, options)

        jsonType = Settings.findOne({name:"courseTypes"}).value
        this.editorType.set(jsonType)
        # Session.set('courseTypes',editorType)

        containerLiveDay = document.getElementById("settingCourseLiveDaysDiv")
        this['editorLiveDay'] = new JSONEditor(containerLiveDay, options)
        jsonLiveDay = Settings.findOne({name:"liveDays"}).value
        this.editorLiveDay.set(jsonLiveDay)
        null
)


Template.settingCourse.events
    'click #saveSetting':(e,t)->
        # containerType = document.getElementById("settingCourseTypeDiv")
        # editorType = JSONEditor(containerType, {})
        #
        # console.log editorType.get()
        Meteor.call('updateSettings','courseTypes',t.editorType.get(),(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "save courseTypes"
        )
        Meteor.call('updateSettings','liveDays',t.editorLiveDay.get(),(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "save liveDays"
        )
        FlashMessages.sendSuccess("保存了一下课程的配置")

        null
