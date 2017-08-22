Template.todoItem.helpers
    isEditable:()->
        switch this.thisItem.type
            when 7
                if Roles.userIsInRole(Meteor.userId(),this.userId, 'admin')
                    return true
        false
    thisTodo:()->
        thisTodo = this.thisItem
        teachers = []
        titleShow = "【#{thisTodo.catagory}】#{thisTodo.title}"
        _.extend(thisTodo,{titleShow:titleShow})
        thisTodo

Template.todoItem.events
    'submit form': (e,t) ->
        e.preventDefault()
        todoId = $(e.target).find('[name=todoId]').val()
        title = $(e.target).find('[name=title]').val()
        exam = $(e.target).find('[name=exam]').val()
        title ?= ""
        note = $(e.target).find('[name=note]').val()
        note ?= ""
        status = parseInt($(e.target).find('[name=status]:checked').val())
        updateProperties =
            title : title
            status : status
            note : note
        query = t.data.query
        Meteor.call('todoUpdate',todoId,updateProperties, (error,result)->
            if error
                return alert(error.reason)
        	# Router.go('eventPage',{_id: result._id})
            else
                FlashMessages.sendSuccess("你更新了这个TODO！")
                Router.go('examCal',{_exam:exam},{query:$.param(query)})

                # Router.go('activityItem',{_exam:exam, _id: activityID})
        )
        null
