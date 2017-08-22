Meteor.methods
    userAddRole: (userId, newRoles, group)->
        Roles.addUsersToRoles(userId, newRoles,group)
        null
    userRemoveRole:(userId, oldRoles, group)->
        Roles.removeUsersFromRoles( userId, oldRoles,group )
        null
    userSetTodoCatagories:(newCatagories)->
        check(Meteor.userId(), String)
        check(newCatagories,Array)
        thisUser = Meteor.user()
        thisUser['todoCatagories'] = newCatagories
        Meteor.users.update({_id:Meteor.userId()},{$set:{todoCatagories:newCatagories}},(error)->
            if error
                console.log error

            )
    userSetNickname:(uid,nickName)->
        check(Meteor.userId(), String)
        check(nickName, String)
        Meteor.users.update({_id:uid},{$set:{nickName:nickName}},(error)->
            if error
                console.log error

            )
