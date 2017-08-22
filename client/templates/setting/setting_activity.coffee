Template.settingActivity.onRendered(
    ()->
        options = {}
        container = document.getElementById("settingDiv")
        this['jsonEditor'] = new JSONEditor(container, options)
        json = Settings.findOne({name:"activityTypes"}).value
        this.jsonEditor.set(json)
        null
)

Template.settingActivity.events
    'click #saveSetting':(e,t)->

        Meteor.call('updateSettings','activityTypes',t.jsonEditor.get(),(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "save activityTypes"
        )
        FlashMessages.sendSuccess("保存了一下考试的配置")
        null
