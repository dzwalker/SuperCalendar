Template.settingOrder.onRendered(
    ()->
        options = {}
        container = document.getElementById("settingDiv")
        this['jsonEditor'] = new JSONEditor(container, options)
        json = Settings.findOne({name:"configureIndex"}).value
        this.jsonEditor.set(json)
        null
)

Template.settingOrder.events
    'click #saveSetting':(e,t)->
        # containerType = document.getElementById("settingCourseTypeDiv")
        # editorType = JSONEditor(containerType, {})
        #
        # console.log editorType.get()
        Meteor.call('updateSettings','configureIndex',t.jsonEditor.get(),(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "save configureIndex"
        )
        FlashMessages.sendSuccess("保存了一下显示顺序的配置")
        null
