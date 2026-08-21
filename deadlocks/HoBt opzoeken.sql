-- HoBt ID (uit SQL trace) opzoeken in DB:

SELECT * 
FROM sys.partitions
WHERE hobt_id = 7854277754562871296;

SELECT OBJECT_NAME(object_id)
FROM sys.partitions
WHERE hobt_id = 7854277754562871296;	-- tabelA of tabelB


Select Events to Capture

Go to the Events Selection tab.

Click on "Show all events" at the bottom right.

Expand these event categories:

Errors and Warnings

✅ Check Deadlock graph

✅ Check Lock:Deadlock

✅ Check Lock:Deadlock Chain

Optionally, include:

RPC:Completed

SQL:BatchCompleted

SQL:BatchStarting

SP:StmtCompleted (if you're tracing stored procedures)