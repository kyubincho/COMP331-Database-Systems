# COMP3311 19T3 Assignment 3

import cs3311
conn = cs3311.connect()

cur = conn.cursor()

# TODO

import sys
argument = sys.argv[1]

query = """
    SELECT distinct T.name, S.code, count(CE.person_id)
    FROM Course_Enrolments CE, 
         Courses C JOIN Terms    T on C.term_id = T.id
                   JOIN Subjects S on C.subject_id = S.id
    WHERE S.code ilike '{}' || '%' and CE.course_id = C.id
    GROUP BY T.name, S.code
    ORDER BY T.name
""".format(argument)

cur.execute(query)
dictionary = {}
for term, code, nEnrolment in cur.fetchall():
    
    subj = str(code) + "(" + str(nEnrolment) + ")"
    
    if not term in dictionary:
        dictionary[term] = [subj]
    else:
        dictionary[term].append(subj)   
        
for term, subj in sorted(dictionary.items()):
    print(term + "\n " + "\n ".join(subj))

cur.close()
conn.close()
