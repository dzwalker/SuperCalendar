Template.home.helpers
    exams:()->
        exams = []
        for exam in ['toefl','t6','gre','gmat','ielts']
            exams.push {_exam:{_exam: exam},  words: exam.toUpperCase()}
        exams
