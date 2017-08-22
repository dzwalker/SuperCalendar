Template.todoEventNew.onRendered(
    ()->
        # this.$('.datetimepicker').datetimepicker({
        #     format:"YYYYMMDD"
        # })
        this.$('.datepicker').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1

            # setDate: moment(this.$('.datepicker').val(),"YYYYMMDD").toDate()
        })
        # this.$('.datepicker').datepicker('setDate',moment(this.$('.datepicker').val(),"YYYYMMDD").toDate())
        null

)

Template.todoEventNew.events
    'submit form': (e,t) ->

        e.preventDefault()
        # dp = $('.datetimepicker').data("DateTimePicker")
        # duetime = dp.date().toDate()
        duetime = $('.datepicker').datepicker('getDate')
        title = $(e.target).find('[name=title]').val()
        title ?= ""
        note = $(e.target).find('[name=note]').val()
        note ?= ""
        type = 7
        catagory = $(e.target).find('[name=catagory]:checked').val()

        exam = $(e.target).find('[name=exam]').val()

        todo =
            duetime : duetime
            title : title
            type : type
            catagory : catagory
            userId : exam
            note : note

        # console.log activity
        query = t.data.query
        if 'date' of query
            delete query.date
        Meteor.call('todoInsert',todo, (error,result)->
            if error
                return alert(error.reason)
        	# Router.go('eventPage',{_id: result._id})
            else
                FlashMessages.sendSuccess("你创建了一个事件！")

                Router.go('superCalendar',{_exam:exam},{query:$.param(query)})
        )
        null

Template.todoEventNew.helpers
    _exam:()->
        this._exam
    duetime:()->
        if "date" of this.query
            return moment(this.query.date,"YYYYMMDD").format("YYYY/MM/DD")
        else
            return moment(0,"hh").format("YYYY/MM/DD")
        null
    todoCatagories:()->
        exam  = this._exam
        FormOption.todoCatagories(exam,[])
    teachers:()->
        exam = this._exam
        nameType = "nickName"
        FormOption.teachers(exam, nameType, [])
