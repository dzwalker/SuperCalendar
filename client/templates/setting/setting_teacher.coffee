Template.settingTeacher.onRendered(
    ()->
        options = {}
        container = document.getElementById("settingDiv")
        this['jsonEditor'] = new JSONEditor(container, options)
        json = Settings.findOne({name:"teachers"}).value
        this.jsonEditor.set(json)
        null
)


Template.settingTeacher.events
    'click #saveSetting':(e,t)->
        Meteor.call('updateSettings','teachers',t.jsonEditor.get(),(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "save teachers"
        )
        FlashMessages.sendSuccess("保存了一下老师的配置")
        null
