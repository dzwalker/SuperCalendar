Template.usersList.helpers
    users:()->
        users = []
        usersCursor = Meteor.users.find()
        usersCursor.forEach((user)->
            if "nickName" not of user
                Meteor.call("userSetNickname",user._id,"unset",(error,restult)->
                    if error
                        console.log error
                    )
            thisUserRoles = []
            groups = {adminGroup:''}
            _.extend(groups,DefaultConfigure.exams,DefaultConfigure.otherApps)
            for group of groups
                rolesInThisGroup = []
                for role in DefaultConfigure.roles
                    if Roles.userIsInRole(user._id,role,group)
                        rolesInThisGroup.push {role:role, isRole:true, userId: user._id, group:group}
                    else
                        rolesInThisGroup.push {role:role, isRole:false, userId: user._id, group:group}
                thisUserRoles.push {group:group, rolesInThisGroup:rolesInThisGroup}
            users.push _.extend(user,{groups: thisUserRoles})
        )
        users



Template.usersList.events
    'change [name=roles]':(e,t)->
        userId = this.userId
        roles = [this.role]
        group = this.group
        console.log userId,roles,group
        if $(e.target).is(":checked")
            # Roles.addUsersToRoles(userId, role)

            Meteor.call('userAddRole', userId, roles,group , (error,result)->
                if error
                    return alert(error.reason)
            	# Router.go('eventPage',{_id: result._id})
                else
                    # Router.go('examCal',{_exam:exam})
                    console.log "addUsersToRoles succeed!"
            )
        else
            Meteor.call('userRemoveRole', userId, roles, group , (error,result)->
                if error
                    return alert(error.reason)
            	# Router.go('eventPage',{_id: result._id})
                else
                    # Router.go('examCal',{_exam:exam})
                    console.log "userRemoveRole succeed!"
            )

        null
