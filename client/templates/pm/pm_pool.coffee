Template.pmPool.helpers
    itemsInPool:()->
        queryProjects =
            deadline:null
        projects = Projects.find(queryProjects,{sort:{submitted:1}})
        projects
