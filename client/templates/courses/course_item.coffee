Template.courseItem.onCreated(
    ()->
        this.liveDays = new ReactiveVar(this.data.thisCourse.liveDays)
        Session.set("courseTeachers",this.data.thisCourse.teachers)
)
Template.courseItem.helpers
    liveDaysString:()->
        Template.instance().liveDays.get().join(',')
    liveDateAndTime:()->
        liveDatesString = ""
        liveDateAndTimeArray = []
        thisCourse = this.thisCourse
        dateBegin = moment(thisCourse.dateBegin)
        liveDays = Template.instance().liveDays.get()
        specialLiveTimeArray = thisCourse.specialLiveTime
        liveTimeDefault = thisCourse.liveTimes
        courseTeachers = thisCourse.teachers
        courseLiveTeachers = []
        settingTeachers = Settings.findOne({name:'teachers'}).value

        for i in [0...liveDays.length]
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
            liveDateAndTimeArray.push {date : date, liveTime:liveTime, order:i, liveTeachers: liveTeachers}
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
            # teachers.push $(this).val()
            specialLiveTime.push parseInt($(this).val())
        )
        liveTeachers = []
        $.each($(e.target).find('[name=liveTeachers]'),()->
            # teachers.push $(this).val()
            liveTeachers.push $(this).val()
        )
        liveDays = []
        liveDaysString = $(e.target).find('[name=liveDays]').val().split(',')
        for liveDay in liveDaysString
            liveDays.push parseInt(liveDay)
        # specialLiveTimeString = $(e.target).find('[name=specialLiveTime]').val().split(',')
        # for oneSpecialLiveTimeString in specialLiveTimeString
        #     oneSpecialLiveTime = parseInt(oneSpecialLiveTimeString)
        #     if oneSpecialLiveTime>0
        #         specialLiveTime.push oneSpecialLiveTime
        #     else
        #         specialLiveTime.push null

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
        # console.log activity
        query = t.data.query
        Meteor.call('courseUpdate',courseId,updateProperties, (error,result)->
            if error
                return alert(error.reason)
        	# Router.go('eventPage',{_id: result._id})
            else
                FlashMessages.sendSuccess("你更新了这个课！")
                Router.go('examCal',{_exam:exam},{query:$.param(query)})

                # Router.go('courseItem',{_exam:exam, _id: courseId})
        )
        null

    'blur #liveDays':(e,t)->
        liveDaysStringArray = $("#liveDays").val().split(',')
        newLiveDays = []
        # console.log "liveDaysStringArray",liveDaysStringArray
        for liveDayString in liveDaysStringArray
            newLiveDays.push parseInt(liveDayString)
        t.liveDays.set(newLiveDays)
        null
