root = exports ? this
root.ProjectObjects = new Mongo.Collection('projectObjects')

Meteor.methods
    projectAddObject: (objectAttributes)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            check(Meteor.userId(), String)
            check(objectAttributes,{title: String, projectId: String}) #所有插入的内容都要在这里声名
            user = Meteor.user()
            projectObject = _.extend(objectAttributes,{
                userId : user._id
                submitted : new Date()
                status : 0
            })
            projectObjectId = ProjectObjects.insert(projectObject)
            return {_id : projectObjectId}
        null
    projectDelObject: (objectId)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            check(Meteor.userId(), String)
            check( objectId, String)
            updateProperties = {status : 9}
            ProjectObjects.update({_id:objectId},{$set:updateProperties},(error)->
                if error
                    console.log error
                else
                    console.log 'updateProperties success'
            )
        null
