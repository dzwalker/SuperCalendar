Template.settingMore.events
    'click #resetConfigure':(e,t)->
        if $("input[name=resetDefault]").is(':checked')
            Meteor.call('resetConfigure',(error,result)->
                if error
                    return alert(error.reason)
                else
                    console.log "resetConfigure"
                    FlashMessages.sendSuccess("重置了配置数据！")
            )
        else
            alert "你不知道怎么重置数据吧？？！！"

        null
    'click #updateTodosType':(e,t)->
        if $("input[name=updateTodosType]").is(':checked')
            Meteor.call('updateTodosType',3,(error,result)->
                if error
                    return alert(error.reason)
                else
                    console.log "updateTodosType"
                    FlashMessages.sendSuccess("更新了todo的type数据")
            )
            Meteor.call('updateTodosType',2,(error,result)->
                if error
                    return alert(error.reason)
                else
                    console.log "updateTodosType"
                    FlashMessages.sendSuccess("更新了todo的type数据")
            )
        else
            alert "你不知道怎么更新todo的type数据吧？？！！"

        null
