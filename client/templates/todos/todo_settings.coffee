Template.todoMySettings.helpers
	catagories: ()->
        catagories = Meteor.user().todoCatagories
        if catagories is undefined
            catagories = []
        catagories.join(';')

Template.todoMySettings.events
    'submit form': (e,t) ->
        e.preventDefault()
        catagoriesStr = $(e.target).find('[name=catagories]').val()
        catagories = catagoriesStr.split(/;|；/)
        Meteor.call('userSetTodoCatagories',catagories, (error,result)->
                if error
                    console.log error
                else
                    FlashMessages.sendSuccess("保存成功")
                    Router.go('todoWeekly')
            )
