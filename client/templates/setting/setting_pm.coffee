Template.settingPm.onRendered(
    ()->
        options = {}
        container = document.getElementById("settingDiv")
        this['jsonEditor'] = new JSONEditor(container, options)
        json = Settings.findOne({name:"pm"}).value
        this.jsonEditor.set(json)
        null
)

Template.settingPm.events
    'click #saveSetting':(e,t)->
        # containerType = document.getElementById("settingCourseTypeDiv")
        # editorType = JSONEditor(containerType, {})
        #
        # console.log editorType.get()
        Meteor.call('updateSettings','pm',t.jsonEditor.get(),(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "save pm"
        )
        FlashMessages.sendSuccess("保存了一下小本本的配置")
        null
