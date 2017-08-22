Template.activityNew.onRendered(
    ()->

        this.$('.datepicker').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1

            # setDate: moment(this.$('.datepicker').val(),"YYYYMMDD").toDate()
        })
        # this.$('.datepicker').datepicker('setDate',moment(this.$('.datepicker').val(),"YYYYMMDD").toDate())
        null

)

Template.activityNew.events
    'submit form': (e,t) ->

        e.preventDefault()
        # dp = $('.datetimepicker').data("DateTimePicker")
        # duetime = dp.date().toDate()
        duetime = $('.datepicker').datepicker('getDate')
        title = $(e.target).find('[name=title]').val()
        title ?= ""
        detail = $(e.target).find('[name=detail]').val()
        detail ?= ""
        note = $(e.target).find('[name=note]').val()
        note ?= ""
        type = $(e.target).find('[name=type]:checked').val()
        exam = $(e.target).find('[name=exam]').val()
        status = parseInt($(e.target).find('[name=status]:checked').val())
        teachers = []
        $.each($(e.target).find('[name=teachers]:checked'),()->
            teachers.push $(this).val()
        )
        if type is undefined
            alert '请选择活动类型'
            return null
        if teachers.length < 1
            alert '请选择老师!'
            return null
        activity =
            duetime : duetime
            title : title
            detail : detail
            type : type
            teachers : teachers
            exam : exam
            status : status
            note : note

        # console.log activity
        query = t.data.query
        if 'date' of query
            delete query.date
        Meteor.call('activityInsert',activity, (error,result)->
            if error
                return alert(error.reason)
        	# Router.go('eventPage',{_id: result._id})
            else
                FlashMessages.sendSuccess("你创建了一个活动！")

                Router.go('examCal',{_exam:exam},{query:$.param(query)})
        )
        null

Template.activityNew.helpers
    _exam:()->
        this._exam
    duetime:()->
        if "date" of this.query
            return moment(this.query.date,"YYYYMMDD").format("YYYY/MM/DD")
        else
            return moment(0,"hh").format("YYYY/MM/DD")
        null
    activityTypes:()->
        FormOption.activityTypes()
    teachers:()->
        exam = this._exam
        nameType = "nickName"
        FormOption.teachers(exam, nameType, [])
