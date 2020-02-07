# COMP3311 19T3 Assignment 3

import cs3311
conn = cs3311.connect()

cur = conn.cursor()

# TODO

import sys
argument = sys.argv[1]

query = """
    SELECT R.id, M.start_time, M.end_time, M.weeks
    FROM Terms T JOIN Courses C on T.id = C.term_id
                 JOIN Classes CL on CL.course_id = C.id
                 JOIN Meetings M on M.class_id = CL.id
                 JOIN Rooms R on M.room_id = R.id
    WHERE T.name = '{}' and R.code like 'K-%'
    ORDER BY R.id
""".format(argument)

roomCount = """
    SELECT R.code
    FROM Rooms R
    WHERE R.code like 'K-%'
    GROUP BY R.code
    ORDER BY R.code
"""

def toBinary(weeks):
    binary = ['0'] * 11
    nums = weeks.split(",")
    if 'N' in weeks or '<' in weeks:
        return binary
    for week in nums:
        if not week.isdigit():
            w = week.split("-")
            start = int(w[0])
            end = int(w[1])
            for i in range(start - 1, end):
                binary[i] = '1'
        else:
            binary[int(week) - 1] = '1'
    return binary     
    
def toMinutes(time):
    (q, r) = divmod(time, 100)
    minutes = q * 60 + r
    return minutes
    
cur.execute(query)
dictionary = {}
for room, start, end, weeks in cur.fetchall():
    binary = toBinary(weeks)
    startMins = toMinutes(start)
    endMins = toMinutes(end)
    duration = endMins - startMins
    
    if not room in dictionary:
        dictionary[room] = [0] *10
    for i in range(0, 10):
        if binary[i] == '1':
            dictionary[room][i] += duration
   
overused = 0         
for room, weeks in sorted(dictionary.items()):
    avg = sum(weeks) / float(len(weeks))
    if avg >= 1200:
        overused += 1
        
cur = conn.cursor()
cur.execute(roomCount)
nRooms = len(cur.fetchall())

percentage = (float(nRooms - overused)/float(nRooms)) * 100
print(str(round(percentage, 1)) + "%")
    
    
cur.close()
conn.close()
