Template.courseNew.onCreated(
    ()->
        # this._exam = new ReactiveVar(this.data._exam)
        # console.log "onCreated"
        # Session.set( "_exam", this.data._exam )
        Session.set("courseTypeSelected", "aio")
        null
)

Template.courseNew.onRendered(
    ()->
        # this.$('.datetimepicker').datetimepicker({
        #     format:"YYYYMMDD"
        # })
        this.$('.datepicker').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1

        })
        # this.$('.datepicker').datepicker('setDate',moment(this.$('.datepicker').val(),"YYYYMMDD").toDate())
        null

)

Template.courseNew.events
    'change input[name=type]':(e,t)->
        courseTypeSelected = $('input[name=type]:checked').val()
        Session.set("courseTypeSelected",courseTypeSelected)
    'submit form': (e,t) ->
        e.preventDefault()
        type = $(e.target).find('[name=type]:checked').val()
        note = $(e.target).find('[name=note]').val()
        note ?= ""
        subject = $(e.target).find('[name=subject]:checked').val()
        dateBegin = $(e.target).find('[name=dateBegin]:checked').val()
        liveDays = $(e.target).find('[name=liveDays]:checked').val()
        liveTimes = $(e.target).find('[name=liveTimes]:checked').val()
        status = parseInt($(e.target).find('[name=status]:checked').val())
        teachers = []
        $.each($(e.target).find('[name=teachers]:checked'),()->
            teachers.push $(this).val()
            )

        dateBegin = $('.datepicker').datepicker('getDate')

        detail = $(e.target).find('[name=detail]').val()
        detail ?= ""

        exam = $(e.target).find('[name=exam]').val()

        settingLiveDays = Settings.findOne({name:'liveDays'}).value

        # console.log "status:::",status
        if type is undefined
            alert '请选择课程类型'
            return null
        if subject is undefined
            alert '请选择科目'
            return null

        if liveDays is undefined
            alert '请选择直播日'
            return null

        if not liveTimes>0
            alert '选择直播时间！'
            return null
        if teachers.length < 1
            alert '请选择老师!'
            return null

        course =
            type : type
            subject : subject
            dateBegin : dateBegin
            liveDays : settingLiveDays[exam][type][liveDays]
            liveTimes : parseInt(liveTimes)
            teachers : teachers
            detail : detail
            exam : exam
            status : status
            note : note

        console.log course
        query = t.data.query
        if 'date' of query
            delete query.date
        Meteor.call('courseInsert',course, (error,result)->
            if error
                console.log error.reason
                return alert(error.reason)
            else
                FlashMessages.sendSuccess("你创建了一个课！")

                Router.go('examCal',{_exam:exam},{query:$.param(query)})
        )
        null

Template.courseNew.helpers
    dateBegin:()->
        if "date" of this.query
            return moment(this.query.date,"YYYYMMDD").format("YYYY/MM/DD")
        else
            return moment(0,"hh").format("YYYY/MM/DD")
        null
    courseTypes:()->
        exam = this._exam
        FormOption.courseTypes(exam,[])

    subjects:()->
        exam = this._exam
        FormOption.examSubjects(exam,[])
    liveDays:()->
        exam = this._exam
        FormOption.liveDays(exam,Session.get("courseTypeSelected"))
    liveTimes:()->
        FormOption.liveTimes()
    teachers:()->
        exam = this._exam
        nameType = "nickName"
        FormOption.teachers(exam, nameType,[])
    _exam:()->
        this._exam
