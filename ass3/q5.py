# COMP3311 19T3 Assignment 3

import cs3311
conn = cs3311.connect()

cur = conn.cursor()

# TODO

import sys
argument = sys.argv[1]

query = """
    SELECT CT.name, Cl.tag, count(CE.person_id), Cl.quota
    FROM Class_Enrolments CE,
         Courses C JOIN Terms      T on C.term_id = T.id
                   JOIN Subjects   S on C.subject_id = S.id
                   JOIN Classes    Cl on C.id = Cl.course_id
                   JOIN ClassTypes CT on Cl.type_id = CT.id
    WHERE T.name = '19T3' and CE.class_id = Cl.id and S.code = '{}'
    GROUP BY CT.name, Cl.tag, Cl.quota
    HAVING count(CE.person_id) < Cl.quota/2
    ORDER BY CT.name
""".format(argument)

cur.execute(query)
for classT, tag, nEnrolment, quota in cur.fetchall():
    percentage = (float(nEnrolment)/float(quota)) * 100
    print(classT.strip() + " " + tag.strip() + " is " + str(int(round(percentage))) + "% full")

cur.close()
conn.close()
