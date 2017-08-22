Template.todoMyCalOneWeek.helpers
    todoMyCalDays:()->
            # queryTeachers = Template.parentData(4).data.queryTeachers
        console.log 'todoMyCalOneWeek',Template.parentData(2).data.weeks
        Template.parentData(2).data.weeks[0]
