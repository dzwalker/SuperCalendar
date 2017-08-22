root = exports ? this
root.ProjectCheckpoints = new Mongo.Collection('projectCheckpoints')

Meteor.methods
    projectAddCheckpoint: (checkpointAttributes)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            check(Meteor.userId(), String)
            check(checkpointAttributes,{title: String, projectId: String, date:Date}) #所有插入的内容都要在这里声名
            user = Meteor.user()
            projectCheckpoint = _.extend(checkpointAttributes,{
                userId : user._id
                submitted : new Date()
                status : 0
            })
            projectCheckpointId = ProjectCheckpoints.insert(projectCheckpoint)
            return {_id : projectCheckpointId}
        null
    projectCheckpointUpdate:(checkpointId, updateProperties)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            ProjectCheckpoints.update({_id:checkpointId},{$set:updateProperties},(error)->
                if error
                    console.log error
                else
                    console.log 'updateProperties success'
            )
        null
    projectDelCheckpoint: (checkpointId)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            check(Meteor.userId(), String)
            check( checkpointId, String)
            updateProperties = {status : 9}
            ProjectCheckpoints.update({_id:checkpointId},{$set:updateProperties},(error)->
                if error
                    console.log error
                else
                    console.log 'updateProperties success'
            )
        null
