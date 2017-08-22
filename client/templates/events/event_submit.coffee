Template.eventSubmit.onRendered( 
    ()->
        this.$('.datetimepicker').datetimepicker()
        # console.log dp
        # dp.change (e)->
        #     alert e.date
        null

)

Template.eventSubmit.events
    'submit form': (e) ->
        e.preventDefault()
        # sft = new SimpleDateFormat()
        dp = $('.datetimepicker').data("DateTimePicker")
        # alert dp.date()
        event = 
            url : $(e.target).find('[name=url]').val()
            title : $(e.target).find('[name=title]').val()
            detail : $(e.target).find('[name=detail]').val()
            duetime : dp.date().toDate()

        console.log event.duetime

        Meteor.call('eventInsert',event, (error,result)->
        	if error 
        		return alert(error.reason)

        	if result.eventWithSameLink
        		alert("已存在")
        	Router.go('eventPage',{_id: result._id})

        	)
        # Router.go('eventsList')
