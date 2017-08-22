Meteor.publish 'settings',()->
    Settings.find()

Meteor.publish 'users',()->
    Meteor.users.find()

Meteor.publish 'projectObjects',()->
    ProjectObjects.find({status:{$ne:9}})

Meteor.publish 'courseItem',(_id)->
    return Courses.find({_id:_id})

Meteor.publish 'courses',(subscribeMode,exam)->
    query = {status:{$ne:9}}
    if subscribeMode isnt 'allData'
        publishAfterTime = moment().add(-30,"days").toDate()
        _.extend(query,{dateBegin:{$gte:publishAfterTime}})
    if exam isnt 'all'
        _.extend(query,{exam:exam})
    return Courses.find(query)

Meteor.publish 'activityItem',(_id)->
    return Activities.find({_id:_id})

Meteor.publish 'activities',(subscribeMode,exam)->
    query = {status:{$ne:9}}
    if subscribeMode isnt 'allData'
        publishAfterTime = moment().add(-30,"days").toDate()
        _.extend(query,{duetime:{$gte:publishAfterTime}})
    if exam isnt 'all'
        _.extend(query,{exam:exam})
    return Activities.find(query)

Meteor.publish 'todoItem',(_id)->
    return Todos.find({_id:_id})


Meteor.publish 'todosWeekly',(subscribeMode,isAdmin)->
    query = {status:{$ne:9}}
    if not isAdmin
        _.extend(query,{userId:this.userId})
    if subscribeMode isnt 'allData'
        publishAfterTime = moment().add(-30,"days").toDate()
        _.extend(query,{duetime:{$gte:publishAfterTime}})
    return Todos.find(query)



Meteor.publish 'todoEvents',(subscribeMode,exam)->
    query = {status:{$ne:9},type : 7}
    if subscribeMode isnt 'allData'
        publishAfterTime = moment().add(-30,"days").toDate()
        _.extend(query,{duetime:{$gte:publishAfterTime}})
    if exam isnt 'all'
        _.extend(query,{userId:exam})
    return Todos.find(query)

Meteor.publish 'projectItem',(_id)->
    return [
        Projects.find({_id:_id})
        ProjectCheckpoints.find({projectId:_id,status:{$ne:9}})
        ProjectObjects.find({projectId:_id,status:{$ne:9}})
    ]



Meteor.publish 'projectsList',(subscribeMode)->
    query = {status:{$ne:9}}
    fields = {fields:{title:true,status:true,deadline:true,persons:true,topics:true}}
    if subscribeMode isnt 'allData'
        publishAfterTime = moment().add(-30,"days").toDate()
        _.extend(query,{deadline:{$gte:publishAfterTime}})
    return Projects.find(query,fields)

Meteor.publish 'projectCheckpoints',(subscribeMode)->
    query = {status:{$ne:9}}
    if subscribeMode isnt 'allData'
        publishAfterTime = moment().add(-30,"days").toDate()
        _.extend(query,{date:{$gte:publishAfterTime}})
    return ProjectCheckpoints.find(query)
