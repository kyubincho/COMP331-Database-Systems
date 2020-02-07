# COMP3311 19T3 Assignment 3

import cs3311
conn = cs3311.connect()

cur = conn.cursor()

# TODO

query = """
        SELECT S.code, count(CE.person_id), C.quota
        FROM Course_Enrolments CE, 
             Courses C JOIN Subjects S on C.subject_id = S.id 
                       JOIN Terms    T on C.term_id = T.id
        WHERE name = '19T3' and quota > 50 and CE.course_id = C.id
        GROUP BY S.code, C.quota
        HAVING count(CE.person_id) > C.quota
        ORDER BY S.code asc
"""

cur.execute(query)
for code, nEnrolment, quota in cur.fetchall():
    percentage = (float(nEnrolment)/float(quota)) * 100
    print(code + " " + str(int(round(percentage))) + "%")

cur.close()
conn.close()



