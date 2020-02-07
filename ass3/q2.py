# COMP3311 19T3 Assignment 3

import cs3311
conn = cs3311.connect()

cur = conn.cursor()

# TODO

import sys
argument = sys.argv[1]

query = """
        SELECT code
        FROM Subjects
        ORDER BY code asc
"""

cur.execute(query)
dictionary = {}
for code in cur.fetchall():
    nums = code[0][4:]
    subj = code[0][:4]
    
    if not nums in dictionary:
        dictionary[nums] = [subj]
    else:
        dictionary[nums].append(subj)   
        
for nums, subj in sorted(dictionary.items()):
    if int(argument) == len(subj):
        print(nums + ": " + " ".join(subj))
    
cur.close()
conn.close()
