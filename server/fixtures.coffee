superUserName = "zwalker"
superUser = Meteor.users.findOne({username:superUserName})
if superUser
    if not Roles.userIsInRole(superUser,'superAdmin', 'adminGroup')
        Roles.addUsersToRoles(superUser, 'superAdmin', 'adminGroup' )
