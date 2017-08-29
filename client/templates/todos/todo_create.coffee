Template.todoCreate.helpers
	todos: ()->
        null

Template.todoCreate.events
    'submit form': (e,t) ->
        e.preventDefault()
        dateString = this.query["date"]
        year = parseInt(dateString.substr(0,4))
        month = parseInt(dateString.substr(4,2))-1
        dd = parseInt(dateString.substr(6,2))
        duetime = new Date()
        # console.log yearString,monthString,ddString,'kkkkkk'
        # duetime = moment(this.query["date"],"YYYYMMDD")
        duetime.setFullYear(year,month,dd)
        duetime.setMilliseconds(0)

        title = $(e.target).find('[name=title]').val()
        type = parseInt($(e.target).find('[name=type]:checked').val())
        if type is 1
            hour = parseInt($(e.target).find('[name=hour]').val())
            duetime.setHours(hour)
            minute = parseInt($(e.target).find('[name=minute]').val())
            duetime.setMinutes(minute)
            duetime.setSeconds(0)
        else
            duetime.setHours(23)
            duetime.setMinutes(59)
            duetime.setSeconds(59)
        catagory = ""
        title ?= ""
        userId = Meteor.userId()
        todo =
            userId : userId
            duetime : duetime
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
