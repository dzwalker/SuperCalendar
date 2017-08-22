Template.settingExam.onRendered(
    ()->
        options = {}
        container = document.getElementById("settingDiv")
        this['jsonEditor'] = new JSONEditor(container, options)
        json = Settings.findOne({name:"exams"}).value
        this.jsonEditor.set(json)
        null
)

Template.settingExam.events
    'click #saveSetting':(e,t)->

        Meteor.call('updateSettings','exams',t.jsonEditor.get(),(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "save exams"
        )
        FlashMessages.sendSuccess("保存了一下考试的配置")
        null
