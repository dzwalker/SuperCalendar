Template.todoCreate.helpers
    userId:()->
        Session.get("todoUserId")

    defaultTime:()->
        nowTime = moment()
        nowTime.format("HH:mm")


Template.todoCreate.events
    'change input[name=type]':(e,t)->
        currentType = $("input[name=type]:checked").val()
        if currentType is "1"
            $("#divTimeInput").removeClass("hidden")
        else
            $("#divTimeInput").addClass("hidden")

    'submit form': (e,t) ->
        $("#submitTodo").prop('disabled',true)
        $("#submitTodo").val("保存中...")
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
        # duration = 0.0
        if type is 1
            timeStr = $(e.target).find('[name=time]').val()
            # hour = parseInt($(e.target).find('[name=hour]').val())
            hour = timeStr.split(":")[0]
            duetime.setHours(hour)
            # minute = parseInt($(e.target).find('[name=minute]').val())
            minute = timeStr.split(":")[1]
            duetime.setMinutes(minute)
            duetime.setSeconds(0)
            # duration = parseFloat($(e.target).find('[name=duration]').val())
        else
            duetime.setHours(23)
            duetime.setMinutes(59)
            duetime.setSeconds(59)
        catagory = ""
        title ?= ""
        userId = $(e.target).find('[name=userId]').val()
        todo =
            userId : userId
            duetime : duetime
            title : title
            type : type
            catagory : catagory
            # duration : duration
        Meteor.call('todoInsert',todo, (error,result)->
            if error
                return alert(error.reason)
                $("#submitTodo").prop('disabled',false)
                $("#submitTodo").val("创建任务")
            else
                Router.go('todoMyCal')
        )
        null
