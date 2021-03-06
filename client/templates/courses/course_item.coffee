Template.courseItem.onCreated(
    ()->
        this.liveDays = new ReactiveVar(this.data.thisCourse.liveDays)
        Session.set("courseTeachers",this.data.thisCourse.teachers)
)
Template.courseItem.helpers
    isEditable:()->
        if not Roles.userIsInRole(Meteor.userId(),'admin',this._exam)
            console.log this._exam
            console.log "not admin"
            return false
        else
            if 'isLock' not of this.thisCourse
                return true
            else if this.thisCourse.isLock is 0
                return true
            else if Roles.userIsInRole(Meteor.userId(), 'superAdmin',this._exam)
                return true
            else
                return false
        null
    isLocked:()->
        if 'isLock' not of this.thisCourse
            return 0
        else
            console.log "this.thisCourse.isLock",this.thisCourse.isLock
            return this.thisCourse.isLock
        null

    strIsLocked:()->
        strIsLocked = ''
        if 'isLock' of this.thisCourse
            if this.thisCourse.isLock is 1
                strIsLocked = ' - 锁定'
        strIsLocked
    liveDaysString:()->
        Template.instance().liveDays.get().join(',')
    liveDateAndTime:()->
        liveDatesString = ""
        liveDateAndTimeArray = []
        thisCourse = this.thisCourse
        dateBegin = moment(thisCourse.dateBegin)
        liveDays = Template.instance().liveDays.get()
        specialLiveTimeArray = thisCourse.specialLiveTime
        if 'markedLiveTime' of thisCourse
            markedLiveTimeArray = thisCourse.markedLiveTime
        else
            markedLiveTimeArray = []
            for m in [0...liveDays.length]
                markedLiveTimeArray.push 0
        liveTimeDefault = thisCourse.liveTimes
        courseTeachers = thisCourse.teachers
        courseLiveTeachers = []
        settingTeachers = Settings.findOne({name:'teachers'}).value

        for i in [0...liveDays.length]
            if markedLiveTimeArray[i] is 0
                isMarked = false
            else
                isMarked = true
            liveTeachers = []
            liveDay = liveDays[i]
            date = dateBegin.clone().add(liveDay-1,'days').format("MM/DD")
            if specialLiveTimeArray[i]
                liveTime = specialLiveTimeArray[i]
            else
                liveTime = 0
            liveTeachersIsEmpty = false
            if "liveTeachers" not of thisCourse
                liveTeachersIsEmpty = true
                courseLiveTeachers = courseTeachers
            else if thisCourse.liveTeachers is []
                liveTeachersIsEmpty = true
                courseLiveTeachers = courseTeachers
            else
                courseLiveTeachers = thisCourse.liveTeachers

            if liveTeachersIsEmpty
                for j in [0...thisCourse.teachers.length]
                    teacher = thisCourse.teachers[j]
                    if j is 0 then isSelected=true else isSelected=false
                    liveTeachers.push {value : teacher, nickName: settingTeachers[teacher].nickName, isSelected:isSelected}
            else
                sessionCourseTeachers = Session.get("courseTeachers")
                if sessionCourseTeachers.length is 1
                    liveTeachers.push {value : sessionCourseTeachers[0], nickName: settingTeachers[sessionCourseTeachers[0]].nickName, isSelected:true}
                else
                    for teacher in sessionCourseTeachers
                        if courseLiveTeachers[i] is teacher or sessionCourseTeachers[i] is null
                            liveTeachers.push {value : teacher, nickName: settingTeachers[teacher].nickName, isSelected:true}
                        else
                            liveTeachers.push {value : teacher, nickName: settingTeachers[teacher].nickName, isSelected:false}
            liveDateAndTimeArray.push {date : date, liveTime:liveTime, order:i, liveTeachers: liveTeachers,isMarked:isMarked}
        liveDateAndTimeArray
    liveCourses: () ->
        liveCoursesOri = Courses.getLiveCourses([this._id])
        liveCourses = []
        for date, oneDayLiveCourses of liveCoursesOri
            liveCourses.push {"date": date, oneDayLiveCourses: oneDayLiveCourses}
        liveCourses
    thisCourse:()->
        exam = this._exam
        thisCourse = this.thisCourse
        teachers = []
        settingTeachers = Settings.findOne({name:'teachers'}).value

        for t in thisCourse.teachers
            teachers.push settingTeachers[t].shortName
        # dateString = moment(thisCourse.dateBegin).format("MM/DD")
        settingSubjects = Settings.findOne({name:'subjects'}).value

        subject = settingSubjects[thisCourse.subject]["shortName"]
        minute = Math.round(thisCourse.liveTimes%100)
        liveTimes = ""
        if thisCourse.liveTimes%100 is 0
            liveTimes = parseInt(thisCourse.liveTimes/100) + "点"
        else
            if minute > 9
                liveTimes = parseInt(thisCourse.liveTimes/100) + ":" + minute
            else
                liveTimes = parseInt(thisCourse.liveTimes/100) + ":0" + minute
        title = "#{teachers.join()}：#{thisCourse.type}#{subject} #{liveTimes}"
        thisCourse["title"] = title
        thisCourse['liveDaysString'] = thisCourse.liveDays.join(',')
        specialLiveTime = []
        for oneSpecialLiveTime in thisCourse.specialLiveTime
            if oneSpecialLiveTime>0
                specialLiveTime.push oneSpecialLiveTime
            else
                specialLiveTime.push 0
        thisCourse['specialLiveTimeString'] = specialLiveTime.join(',')
        if thisCourse.status is 0
            thisCourse["status0"] = true
            thisCourse["status1"] = false
        else
            thisCourse["status0"] = false
            thisCourse["status1"] = true
        thisCourse
    roleExam:()->
        this._exam
    formTeachers:()->
        exam = this._exam
        thisCourse = this.thisCourse
        nameType = "nickName"
        FormOption.teachers(exam, nameType,Session.get("courseTeachers"))

Template.courseItem.events
    'change [name=teachers]':(e,t)->
        teachers = []
        $.each($('[name=teachers]:checked'),()->
            teachers.push $(this).val()
        )
        console.log teachers
        Session.set("courseTeachers",teachers)
        null
    'submit form': (e,t) ->
        e.preventDefault()
        courseId = $(e.target).find('[name=courseId]').val()
        exam = $(e.target).find('[name=exam]').val()
        note = $(e.target).find('[name=note]').val()
        note ?= ""
        status = parseInt($(e.target).find('[name=status]:checked').val())
        teachers = []
        $.each($(e.target).find('[name=teachers]:checked'),()->
            teachers.push $(this).val()
        )
        specialLiveTime = []
        $.each($(e.target).find('[name=liveTime]'),()->
            specialLiveTime.push parseInt($(this).val())
        )
        markedLiveTime = []
        $.each($(e.target).find('[name=markedLiveTime]'),()->
            console.log $(this).is(":checked"),this
            if $(this).is(":checked")
                console.log 1
                markedLiveTime.push 1
            else
                console.log 0
                markedLiveTime.push 0
        )
        liveTeachers = []
        $.each($(e.target).find('[name=liveTeachers]'),()->
            liveTeachers.push $(this).val()
        )
        liveDays = []
        liveDaysString = $(e.target).find('[name=liveDays]').val().split(',')
        for liveDay in liveDaysString
            liveDays.push parseInt(liveDay)


        if teachers.length < 1
            alert '请选择老师!'
            return null
        updateProperties =
            teachers : teachers
            liveDays : liveDays
            specialLiveTime : specialLiveTime
            status : status
            note : note
            liveTeachers : liveTeachers
            markedLiveTime: markedLiveTime
        # console.log activity
        query = t.data.query
        Meteor.call('courseUpdate',courseId,updateProperties, (error,result)->
            if error
                return alert(error.reason)
        	# Router.go('eventPage',{_id: result._id})
            else
                FlashMessages.sendSuccess("你更新了这个课！")
                Router.go('examCal',{_exam:exam},{query:$.param(query)})
        )
        null

    'blur #liveDays':(e,t)->
        liveDaysStringArray = $("#liveDays").val().split(',')
        newLiveDays = []
        for liveDayString in liveDaysStringArray
            newLiveDays.push parseInt(liveDayString)
        t.liveDays.set(newLiveDays)
        null
    'click .delCourse':(e,t)->
        courseId = e.currentTarget.getAttribute("data-CourseId")
        Meteor.call('courseDelete',courseId,(error,result)->
            if error
                return alert(error.reason)
            else
                FlashMessages.sendError("你消灭了一个课！")

        )
    'click .lockCourse':(e,t)->
        courseId = e.currentTarget.getAttribute("data-CourseId")
        isLocked = parseInt e.currentTarget.getAttribute("data-IsLocked")
        changeIsLocked = 0
        if isLocked is 0
            changeIsLocked = 1
        console.log "changeIsLocked",changeIsLocked, isLocked,isLocked is 0
        Meteor.call('courseUpdate',courseId,{isLock:changeIsLocked},(error,result)->
            if error
                return alert(error.reason)
            else
                FlashMessages.sendError("你锁住/解锁了这个课")

        )
