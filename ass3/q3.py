# COMP3311 19T3 Assignment 3

import cs3311
conn = cs3311.connect()

cur = conn.cursor()

# TODO

import sys
argument = sys.argv[1]

query = """
    SELECT distinct S.code, B.name
    FROM Courses C JOIN Terms     T on C.term_id = T.id
                   JOIN Subjects  S on C.subject_id = S.id
                   JOIN Classes   Cl on C.id = Cl.course_id
                   JOIN Meetings  M on Cl.id = M.class_id
                   JOIN Rooms     R on M.room_id = R.id
                   JOIN Buildings B on R.within = B.id
    WHERE T.name = '19T2' and S.code ilike '{}' || '%'
    ORDER BY S.code
""".format(argument)

cur.execute(query)
dictionary = {}
for code, building in cur.fetchall():
    
    if not building in dictionary:
        dictionary[building] = [code]
    else:
        dictionary[building].append(code)   
        
for building, code in sorted(dictionary.items()):
    print(building + "\n " + "\n ".join(code))

cur.close()
conn.close()
