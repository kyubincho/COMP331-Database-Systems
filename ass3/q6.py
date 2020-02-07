# COMP3311 19T3 Assignment 3

import cs3311
conn = cs3311.connect()

cur = conn.cursor()

# TODO

query = """
    SELECT M.weeks, M.id
    FROM Meetings M
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
        
cur.execute(query)
for weeks, mID in cur.fetchall():
    binary = toBinary(weeks)
    
    cur.execute("UPDATE meetings SET weeks_binary = '{}' WHERE id = {}".format(''.join(binary), mID))

cur.close()

conn.commit()
conn.close()
