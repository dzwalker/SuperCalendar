root = exports ? this
root.Courses = new Mongo.Collection('courses')
Courses["getLiveCourses"] = (_ids)->
    liveCourses = {}
    for _id in _ids
        course = @findOne({ _id : _id})
        for i in [0...course.liveDates.length]
            date = course.liveDates[i]
            oneLiveCourse = {}
            if date not of liveCourses
                liveCourses[date] = []
            if course.specialLiveTime[i]
                oneLiveCourse["time"] = course.specialLiveTime[i]
            else
                oneLiveCourse["time"] = course["liveTimes"]
            oneLiveCourse["title"] = course["type"] + course["subject"]+ "(#{i+1})"
            oneLiveCourse["teachers"] = course["teachers"]
            liveCourses[date].push oneLiveCourse
    liveCourses
Meteor.methods
    courseInsert: (courseAttributes)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            check(Meteor.userId(), String)
            check(courseAttributes,{note: String,type: String,exam:String, subject: String, dateBegin:Date, liveDays: Array, liveTimes:Number,  teachers:Array,  detail:String, status:Number}) #所有插入的内容都要在这里声名
            # console.log "TEST:::",Match.test(courseAttributes,{note: String,type: String,exam:String, subject: String, dateBegin:Date, liveDays: Array, liveTimes:Number,  teachers:Array,  detail:String, status:Number}) #所有插入的内容都要在这里声名
            user = Meteor.user()
            course = _.extend(courseAttributes,{
                userId : user._id
                submitted : new Date()
                specialLiveTime : []
                liveTeachers : []
            })
            courseId = Courses.insert(course)
            Meteor.call("courseGernerateLiveDates",courseId,(error, result)->
                if error
                    console.log error.reason

            )
            return {_id : courseId}
        null
    courseUpdate:(courseId, updateProperties)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            Courses.update({_id:courseId},{$set:updateProperties},(error)->
                if error
                    console.log error
                else
                    Meteor.call("courseGernerateLiveDates",courseId,(error, result)->
                        if error
                            console.log error.reason

                    )
            )
        null
    courseGernerateLiveDates:(courseId)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            course = Courses.findOne({_id: courseId})
            # console.log "course",course
            dateBegin = moment(course.dateBegin)
            # console.log "dateBegin",dateBegin
            liveDates = []
            for i in [0...course.liveDays.length]
                d = course.liveDays[i]
                liveDates.push dateBegin.clone().add(d-1, 'days').format("YYYYMMDD")
            updateProperties =
                liveDates : liveDates
            # console.log "updateProperties",updateProperties
            Courses.update({_id:courseId},{$set:updateProperties},(error)->
                if error
                    console.log error
            )
        null

    courseUpdateDate:(courseId,newDateBegin)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            # console.log "courseUpdateDate",courseId

            check newDateBegin, Date
            updateProperties =
                dateBegin : newDateBegin
            Courses.update({_id:courseId},{$set:updateProperties},(error)->
                if error
                    console.log error
            )
            Meteor.call("courseGernerateLiveDates",courseId,(error, result)->
                if error
                    console.log error.reason

            )
        null
    courseDelete:(courseId)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            updateProperties =
                status : 9
            Courses.update({_id:courseId},{$set:updateProperties},(error)->
                if error
                    console.log error

            )
        null

    courseSpecialLiveTime:(courseId, i, newTime)->
        if Roles.userIsInRole(Meteor.userId(),'admin', 'adminGroup')
            course = Courses.findOne({_id : courseId})
            specialLiveTime = course["specialLiveTime"]
            specialLiveTime[i] = newTime
            updateProperties =
                specialLiveTime : specialLiveTime
            Courses.update({_id:courseId},{$set:updateProperties},(error)->
                if error
                    console.log error
            )
        null
