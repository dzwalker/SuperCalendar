Template.pmCalOneCheckpoint.helpers
    queryString:()->
        query = {}
        _.extend(query,Template.parentData(5).data.query)
        $.param(query)

    cssStyle:()->
        done = "checkpointNotCompleted"
        if this.status is 1
            done = "checkpointCompleted"
        done
    _id:()->
        this._id
    courseQuery:()->
        {_id:this.projectId}

    title:()->
        titleString = ""
        titleString += this.title
        projectId = this.projectId
        project = Projects.findOne({_id:projectId})
        for person in project.persons
            titleString += " @" + person
        for topic in project.topics
            titleString += " #" + topic
        titleString
