Template.weeksAndQuery.helpers
    weeks:()->
        # console.log Template.parentData(1).data
        # console.log Template.parentData(2).data
        Template.parentData(2).data.weeks



Template.weeksAndQuery.onRendered(
    ()->
        daysActivitiesDrake = dragula($('.oneDayActivities').toArray(),{
            # removeOnSpill: true

            })

        daysActivitiesDrake.on("drag",(el,target,source,sibling)->
            $(".oneDayActivities").addClass('dropDestination')
        )
        daysActivitiesDrake.on("cancel",(el,target,source,sibling)->
            $(".oneDayActivities").removeClass('dropDestination')
        )
        daysActivitiesDrake.on("drop",(el,target,source,sibling)->
            $(".oneDayActivities").removeClass('dropDestination')
            newDuetime = moment(target.getAttribute("data-date"),"YYYYMMDD").toDate()
            console.log newDuetime
            Meteor.call('activityUpdateDate',el.id,newDuetime,(error,result)->
                if error
                    return alert(error.reason)
                else
                    FlashMessages.sendSuccess("你调整了一下活动的时间！")

            )
        )

        # daysActivitiesDrake.on('remove',(el, container, source)->
        #     $(".oneDayActivities").removeClass('dropDestination')
        #     Meteor.call('activityDelete',el.id,(error,result)->
        #         if error
        #             return alert(error.reason)
        #         else
        #             FlashMessages.sendError("你消灭了一个活动！")
        #
        #     )
        # )

        daysCourseDrake = dragula($('.oneDayCourses').toArray(),{
            # removeOnSpill : true
        })
        daysCourseDrake.on("drag",(el,target,source,sibling)->
            $(".oneDayCourses").addClass('dropDestination')
        )
        daysCourseDrake.on("cancel",(el,target,source,sibling)->
            $(".oneDayCourses").removeClass('dropDestination')
        )
        daysCourseDrake.on("drop",(el,target,source,sibling)->
            # console.log target
            $(".oneDayCourses").removeClass('dropDestination')

            newDateBegin = moment(target.getAttribute("data-date"),"YYYYMMDD").toDate()
            # console.log newDateBegin
            Meteor.call('courseUpdateDate',el.id,newDateBegin,(error,result)->
                if error
                    return alert(error.reason)
                else
                    FlashMessages.sendSuccess("你调整了课程的时间！")

            )
        )

        # daysCourseDrake.on('remove',(el, container, source)->
        #     $(".oneDayCourses").removeClass('dropDestination')
        #     Meteor.call('courseDelete',el.id,(error,result)->
        #         if error
        #             return alert(error.reason)
        #         else
        #             FlashMessages.sendError("你消灭了一个课！")
        #
        #     )
        # )



)
