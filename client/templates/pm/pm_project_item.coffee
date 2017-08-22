Template.projectItem.onCreated(
    ()->
        null
)
Template.projectItem.onRendered(
    ()->
        this.$('.datepicker').datepicker({
            format:"yyyy/mm/dd"
            weekStart: 1
            autoclose: true

        }).on('changeDate',(e)->
            checkpointId = e.target.getAttribute("data-CheckpointId")
            projectId = e.target.getAttribute("data-projectId")
            if checkpointId
                # console.log e.date
                updateProperties = {date:e.date}
                Meteor.call('projectCheckpointUpdate',checkpointId,updateProperties, (error,result)->
                    if error
                        return alert(error.reason)
                    else
                        Meteor.call("logInsert",{type:"projectCheckpointUpdate-date",objectId:checkpointId,detail:updateProperties})

                        console.log  "你修改了节点时间！"
                        # $("[name=newObjectContent]").val("")
                )
            if projectId
                if e.target.name is 'dateBegin'
                    updateProperties = {dateBegin:e.date}
                else if e.target.name is 'deadline'
                    updateProperties = {deadline:e.date}
                Meteor.call('projectUpdate',projectId,updateProperties, (error,result)->
                    if error
                        return alert(error.reason)
                    else
                        Meteor.call("logInsert",{type:"projectUpdate-date",objectId:projectId,detail:updateProperties})

                        console.log  "你修改了节点时间！"
                        # $("[name=newObjectContent]").val("")
                )
        )
        # Meteor.typeahead.inject()
        null
)
Template.projectItem.helpers
    # settingProjectPerson:()->
    #     ['one','two','three','赵老师']
    thisItem:()->
        this.thisItem
    projectId:()->
        this.thisItem._id
    projectTitle:()->
        this.thisItem.title
    catagories:()->
        catagory = this.thisItem.catagory
        FormOption.pmCatagories([catagory])
    dateBeginString:()->
        dateBegin = moment(this.thisItem.dateBegin)
        dateBegin.format("YYYY/MM/DD")
    deadlineString:()->
        if this.thisItem.deadline isnt null
            deadline = moment(this.thisItem.deadline)
            return deadline.format("YYYY/MM/DD")
        null
    checkpoints:()->
        projectId = this.thisItem._id
        queryCheckpoints = {projectId:projectId}
        checkpoints = []
        checkpointsCursor = ProjectCheckpoints.find(queryCheckpoints,{sort:{date:1}})
        checkpointsCursor.forEach((checkpoint)->
            isChecked = true
            if checkpoint.status is 0
                isChecked = false
            checkpoint["dateString"] = moment(checkpoint.date).format("YYYY/MM/DD")
            checkpoint['isChecked'] = isChecked
            checkpoints.push checkpoint
        )
        checkpoints
    objects:()->
        projectId = this.thisItem._id
        objects = ProjectObjects.find({projectId:projectId},{sort:{submitted:1}})
        objects
    persons:()->
        persons = []
        personsOri = this.thisItem.persons
        projectId = this.thisItem._id
        if personsOri.length is 0
            persons.push {name:"填添加负责人",order:0, project_Id:projectId}
        else
            for i in [0...personsOri.length]
                persons.push {name:personsOri[i],order:i, project_Id:projectId}
        persons
    topics:()->
        topics = []
        topicsOri = this.thisItem.topics
        projectId = this.thisItem._id
        if topicsOri.length is 0
            topics.push {name:"填添加主题",order:0, project_Id:projectId}
        else
            for i in [0...topicsOri.length]
                topics.push {name:topicsOri[i],order:i, project_Id:projectId}
        topics
    projectIsChecked:()->
        status = this.thisItem.status
        if status is 0
            return false
        else if status is 1
            return true
        null
    userCanDelProject:()->
        userCanDelProject = false
        if Roles.userIsInRole(Meteor.userId(),'superAdmin', 'pmCal')
            userCanDelProject = true
        userCanDelProject

Template.projectItem.events
    'change [name=dateCheckpoint]':(e,t)->
        # console.log e.target.getAttribute("data-CheckpointId")
        null
    'change [name=checkCheckpoint]':(e,t)->
        checkpointId = $(e.currentTarget).val()
        checkpointIsChecked = $(e.currentTarget).is(':checked')
        status = 0
        if checkpointIsChecked
            status = 1
        updateProperties = {status:status}
        Meteor.call('projectCheckpointUpdate',checkpointId,updateProperties, (error,result)->
            if error
                return alert(error.reason)
            else
                console.log 'updateProperties: status!'
            )
        null

    'submit form.newObject': (e,t) ->
        e.preventDefault()
        objectContent = $(e.target).find('[name=newObjectContent]').val()
        projectId = $(e.target).find('[name=projectId]').val()
        object =
            title : objectContent
            projectId : projectId
        Meteor.call('projectAddObject',object, (error,result)->
            if error
                return alert(error.reason)
            else
                # FlashMessages.sendSuccess("你添加了一个目标！")
                $("[name=newObjectContent]").val("")
        )
        null
    'submit form.newCheckpoint': (e,t) ->
        e.preventDefault()
        checkpointTitle = $(e.target).find('[name=newCheckpointTitle]').val()
        projectId = $(e.target).find('[name=projectId]').val()
        dateNewCheckpoint = $('#dateNewCheckpoint').datepicker('getDate')
        checkpoint =
            date : dateNewCheckpoint
            projectId : projectId
            title : checkpointTitle

        Meteor.call('projectAddCheckpoint',checkpoint, (error,result)->
            if error
                return alert(error.reason)
            else
                # FlashMessages.sendSuccess("你添加了一个目标！")
                $("[name=newCheckpointTitle]").val("")
        )
        null

    'submit form.newPerson': (e,t) ->
        e.preventDefault()
        person = $(e.target).find('[name=newPerson]').val()
        projectId = $(e.target).find('[name=projectId]').val()
        Meteor.call('projectAddPerson',projectId,person, (error,result)->
            if error
                return alert(error.reason)
            else
                # FlashMessages.sendSuccess("你添加了一个目标！")
                $("[name=newPerson]").val("")
                null
        )
        null
    'submit form.newTopic': (e,t) ->
        e.preventDefault()
        topic = $(e.target).find('[name=newTopic]').val()
        projectId = $(e.target).find('[name=projectId]').val()
        Meteor.call('projectAddTopic',projectId,topic, (error,result)->
            if error
                return alert(error.reason)
            else
                # FlashMessages.sendSuccess("你添加了一个目标！")
                $("[name=newTopic]").val("")
                null
        )
        null
    'click .delObject':(e,t)->
        # console.log e
        Meteor.call('projectDelObject',e.currentTarget.getAttribute("data-ObjectId"), (error,result)->
            if error
                return alert(error.reason)
            else
                console.log 'del it!'
            )
        null
    'click .delCheckpoint':(e,t)->
        # console.log e
        Meteor.call('projectDelCheckpoint',e.currentTarget.getAttribute("data-CheckpointId"), (error,result)->
            if error
                return alert(error.reason)
            else
                console.log 'del it!'
            )
        null
    'click .delPerson':(e,t)->
        # console.log e
        projectId = e.currentTarget.getAttribute("data-projectId")
        order = e.currentTarget.getAttribute("data-order")
        Meteor.call('projectDelPerson',projectId,order, (error,result)->
            if error
                return alert(error.reason)
            else
                console.log 'del it!'
            )
        null
    'click .delTopic':(e,t)->
        # console.log e
        projectId = e.currentTarget.getAttribute("data-projectId")
        order = e.currentTarget.getAttribute("data-order")
        Meteor.call('projectDelTopic',projectId,order, (error,result)->
            if error
                return alert(error.reason)
            else
                console.log 'del it!'
            )
        null

    'click .projectChangeStatus':(e,t)->
        # console.log e
        projectId = e.currentTarget.getAttribute("data-projectId")
        status = parseInt(e.currentTarget.getAttribute("data-status"))
        updateProperties = {status: status}
        Meteor.call('projectUpdate',projectId,updateProperties, (error,result)->
            if error
                return alert(error.reason)
            else
                console.log 'updateProperties: status!'
            )
        null
