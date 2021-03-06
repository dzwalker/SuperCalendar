Template.settingSubject.onRendered(
    ()->
        options = {}
        container = document.getElementById("settingDiv")
        this['jsonEditor'] = new JSONEditor(container, options)
        json = Settings.findOne({name:"subjects"}).value
        this.jsonEditor.set(json)
        null
)

Template.settingSubject.events
    'click #saveSetting':(e,t)->
        # containerType = document.getElementById("settingCourseTypeDiv")
        # editorType = JSONEditor(containerType, {})
        #
        # console.log editorType.get()
        Meteor.call('updateSettings','subjects',t.jsonEditor.get(),(error,result)->
            if error
                return alert(error.reason)
            else
                console.log "save subjects"
        )
        FlashMessages.sendSuccess("保存了一下科目的配置")
        null
