Template.todoCreate.helpers
	todos: ()->
        null

Template.todoCreate.events
    'submit form': (e,t) ->
        e.preventDefault()
        # console.log this.query["date"],"YYYYMMDD"
        duetime = moment(this.query["date"]+"+0800","YYYYMMDDZ")
        duetime.hour(23)
        duetime.minute(59)
        duetime.second(59)
        duetime.millisecond(0)
        # duetime.day(7)
        console.log duetime
        title = $(e.target).find('[name=title]').val()
        type = parseInt($(e.target).find('[name=type]').val())
        catagory = ""
        title ?= ""
        userId = Meteor.userId()
        todo =
            userId : userId
            duetime : duetime.toDate()
            title : title
            type : type
            catagory : catagory
        Meteor.call('todoInsert',todo, (error,result)->
            if error
                return alert(error.reason)
            else
                Router.go('todoMyCal')
        )
        null
