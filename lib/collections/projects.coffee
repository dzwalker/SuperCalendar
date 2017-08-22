root = exports ? this
root.Projects = new Mongo.Collection('projects')

Meteor.methods
    projectInsert: (projectAttributes)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            check(Meteor.userId(), String)
            check(projectAttributes,{title: String,catagory: String, dateBegin:Date,deadline:Match.OneOf(Date,null)}) #所有插入的内容都要在这里声名
            user = Meteor.user()
            project = _.extend(projectAttributes,{
                userId : user._id
                submitted : new Date()
                status : 0
                purpose : ""
                persons : []
                topics : []
            })
            projectId = Projects.insert(project)
            return {_id : projectId}
        null
    projectUpdate:(projectId, updateProperties)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            Projects.update({_id:projectId},{$set:updateProperties},(error)->
                if error
                    console.log error
                else
                    console.log 'updateProperties success'
            )
        null
    projectAddPerson:(projectId, person)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            project = Projects.findOne({_id:projectId})
            settingProject = Settings.findOne({name:"pm"}).value
            if "persons" not of settingProject
                settingProject['persons'] = []
            if person not in settingProject['persons']
                settingProject['persons'].push person
                Meteor.call('updateSettings','pm',settingProject,(error,result)->
                    if error
                        return alert(error.reason)
                    else
                        console.log "save pm"
                )
            if person in project.persons
                return null
            else
                persons = project.persons
                persons.push person
            updateProperties = {persons:persons}
            Projects.update({_id:projectId},{$set:updateProperties},(error)->
                if error
                    console.log error
                else
                    console.log 'updateProperties success'
            )
        null
    projectDelPerson:(projectId, order)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            project = Projects.findOne({_id:projectId})
            persons = project.persons
            persons.splice(order,1)
            updateProperties = {persons:persons}
            Projects.update({_id:projectId},{$set:updateProperties},(error)->
                if error
                    console.log error
                else
                    console.log 'updateProperties success'
            )
        null
    projectAddTopic:(projectId, topic)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            project = Projects.findOne({_id:projectId})
            settingProject = Settings.findOne({name:"pm"}).value
            if "topics" not of settingProject
                settingProject['topics'] = []
            if topic not in settingProject['topics']
                settingProject['topics'].push topic
                Meteor.call('updateSettings','pm',settingProject,(error,result)->
                    if error
                        return alert(error.reason)
                    else
                        console.log "save pm"
                )
            if topic in project.topics
                return null
            else
                topics = project.topics
                topics.push topic
            updateProperties = {topics:topics}
            Projects.update({_id:projectId},{$set:updateProperties},(error)->
                if error
                    console.log error
                else
                    console.log 'updateProperties success'
            )
        null
    projectDelTopic:(projectId, order)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            project = Projects.findOne({_id:projectId})
            topics = project.topics
            topics.splice(order,1)
            updateProperties = {topics:topics}
            Projects.update({_id:projectId},{$set:updateProperties},(error)->
                if error
                    console.log error
                else
                    console.log 'updateProperties success'
            )
        null
