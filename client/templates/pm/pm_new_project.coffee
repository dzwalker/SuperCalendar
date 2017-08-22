Template.pmNewProject.onCreated(
    ()->
        # this.liveDays = new ReactiveVar(this.data.thisCourse.liveDays)
        # Session.set("courseTeachers",this.data.thisCourse.teachers)
        null
)
Template.pmNewProject.onRendered(
    ()->
        this.$('.datepicker').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1

        })
        # this.$('#deadline').datepicker('setDate',moment(this.$('#deadline').val(),"YYYY/MM/DD").toDate())
        # this.$('#dateBegin').datepicker('setDate',moment(this.$('#dateBegin').val(),"YYYY/MM/DD").toDate())
        null
)
Template.pmNewProject.helpers
    deadlineString:()->
        if "deadline" of this.query
            return moment(this.query.deadline,"YYYYMMDD").format("YYYY/MM/DD")
        # else
        #     return moment(0,"hh").format('YYYY/MM/DD')
        null
    dateBeginString:()->
        startDate = moment(0,"hh")
        startDate.format('YYYY/MM/DD')
    pmCatagories:()->
        FormOption.pmCatagories([])

Template.pmNewProject.events
    'submit form': (e,t) ->
        e.preventDefault()
        catagory = $(e.target).find('[name=catagory]:checked').val()

        dateBegin = $('#dateBegin').datepicker('getDate')
        deadline = $('#deadline').datepicker('getDate')
        console.log deadline
        title = $(e.target).find('[name=title]').val()

        if title is ''
            alert '请填写白条的内容'
            return null

        if catagory is undefined
            alert '请选择任务类型'
            return null
        $("#submitProject").prop('disabled',true)
        $("#submitProject").val("保存中...")
        project =
            catagory : catagory
            title : title
            dateBegin : dateBegin
            deadline : deadline

        query = t.data.query
        if 'deadline' of query
            delete query.deadline
        Meteor.call('projectInsert',project, (error,result)->
            if error
                console.log error.reason
                $("#submitProject").prop('disabled',false)
                $("#submitProject").val("添加白条")

                return alert(error.reason)
            else
                # FlashMessages.sendSuccess("你创建了一个project！")
                Meteor.call("logInsert",{type:"projectInsert",objectId:result._id,detail:{}})


                Router.go('projectItem',result,{query:$.param(query)})
        )
        null
