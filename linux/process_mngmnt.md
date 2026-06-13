I created a background process using yes > /dev/null &. The yes command continuously generates output,
and /dev/null discards that output.
The & operator ran the process in the background. I then used ps aux | grep yes to locate the process,
and identify its PID (1753).
The process was consuming nearly 100% CPU because it continuously generated output.
I terminated the process using kill 1753, which sent a termination signal to the process and 
stopped it successfully.
