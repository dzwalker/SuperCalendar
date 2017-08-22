root = exports ? this
root.Activities = new Mongo.Collection('activities')
Meteor.methods
    activityInsert: (activityAttributes)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            check(Meteor.userId(), String)
            check(activityAttributes,{title: String, detail:String, exam:String, duetime:Date, type: String, note: String, teachers:Array, status: Number}) #所有插入的内容都要在这里声名
            user = Meteor.user()
            activity = _.extend(activityAttributes,{
                userId : user._id
                submitted : new Date()
            })
            activityId = Activities.insert(activity)

            return {_id : activityId}
        null
    activityUpdateDate:(activityId,newDuetime)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            check newDuetime, Date
            updateProperties =
                duetime : newDuetime
            Activities.update({_id:activityId},{$set:updateProperties},(error)->
                if error
                    console.log error

            )
        null
    activityUpdate:(activityId, updateProperties)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            Activities.update({_id:activityId},{$set:updateProperties},(error)->
                if error
                    console.log error
            )
        null
    activityDelete:(activityId)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            updateProperties =
                status : 9
            Activities.update({_id:activityId},{$set:updateProperties},(error)->
                if error
                    console.log error
            )
        null
