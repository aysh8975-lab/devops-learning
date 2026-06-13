#OverTheWire Bandit Notes (Levels 1–20)
##Level 0 → Level 1
###Objective

Retrieve the password stored in the readme file.

###Commands Tried

ls
cat readme

###Solution
cat readme
Password for l0: ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If

###Explanation
ls lists files in the current directory.
cat displays the contents of a file.

###What I Learned

Basic file navigation and how to read files from the terminal.

##Level 1 → Level 2
###Objective

###Read the contents of a file named -.

###Commands Tried
cat -

###Why It Failed

- is interpreted as standard input instead of a filename.

###Solution
cat ./-
###Explanation

./ tells Linux to treat - as a file in the current directory.

###What I Learned

Some filenames require explicit paths because they conflict with shell syntax.

Password for level 1-2: 263JGJPfgU6LtdEvgfWU1XP5yac29mFx

##Level 2 → Level 3
###Objective

Read a file with spaces in its name.

###Commands Tried
cat spaces in this filename

###Why It Failed

The shell treated each word as a separate argument.

###Solution
cat "spaces in this filename"

###Alternative also tested and worked:

cat spaces\ in\ this\ filename
###What I Learned

How quotes works in the shell when it comes to files with spaces in the name.

Password for Level 2-3: MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx

##Level 3 → Level 4
###Objective
The password for the next level is stored in a hidden file in the inhere directory.


Find a hidden file inside the inhere directory.

###Commands Tried
cd inhere
ls

###Why It Failed

Regular ls does not show hidden files.

###Solution
ls -la
cat .hidden

###Explanation
-a shows hidden files.
Hidden files begin with ..

###What I Learned

Linux hides files using dot-prefixed filenames.

Password for Bandit4: 2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ

##Level 4 → Level 5
###Objective
The password for the next level is stored in the only human-readable file in the inhere directory. Tip: if your terminal is messed up, try the “reset” command.

Find the only human-readable file.

###Commands Tried
file ./*

##Solution
file ./*
cat ./-file07

###Explanation

The file command identifies file types.

###What I Learned

How to distinguish binary files from readable text files.
Password for next level: 4oQYVPkxZOOEOO5pTW81FB8j8lxXGUQw

##Level 5 → Level 6
###Objective

Find a file that is:

Human-readable
Exactly 1033 bytes
Not executable

###Solution
find . -type f -size 1033c ! -executable

###Explanation
find command searches files.
-type f limits results to files.
-size 1033c means exactly 1033 bytes.
! -executable excludes executable files.

###What I Learned

How to combine multiple filters with find.

Password for next level: HWasnPhtq9AVKe0dmk45nxy20cvUa6EG

##Level 6 → Level 7
###Objective
The password for the next level is stored somewhere on the server and has all of the following properties:

owned by user bandit7
owned by group bandit6
33 bytes in size

Find a file of a specific size, owned by a specific user and group.

###Solution

find / -user bandit7 -group bandit6 -size 33c 2>/dev/null
###Explanation
I recursively searched through root and filtered using find command using -users -group and -size c=bytes
Exact command used: find / -group bandit6 -user bandit7 -size 33c 2> /dev/null

Used at the end of command to get rid of permission denied errors

2> /dev/null
= redirect stderr into Linux trash can

2>/dev/null suppresses permission errors.
Searching from / scans the whole filesystem.


###What I Learned

How Linux separates standard output and error output.

Password: morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj

##Level 7 → Level 8
###Objective
The password for the next level is stored in the file data.txt next to the word millionth


Find the password next to the word millionth.

###Solution
grep millionth data.txt

###Explanation

grep searches for matching text inside files.

###What I Learned

How to search file contents efficiently using grep.

Password for next level: dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc

##Level 8 → Level 9
###Objective
The password for the next level is stored in the file data.txt and is the only line of text that occurs only once

Find the unique line in a file.

###Solution
sort data.txt | uniq -u

###Explanation
sort organizes lines alphabetically.
uniq -u shows only unique lines.
uniq works properly only on sorted input.

###What I Learned

How pipes connect commands together.

Password: 4CKMh1JI91bUIZZPXDqGanal4xvAg0JM

##Level 9 → Level 10
###Objective

Find the password hidden inside binary data.

###Solution
strings data.txt | grep =

###Explanation
strings extracts readable text from binary files.
grep filters matching lines.

###What I Learned

Binary files can still contain readable strings.

Password: FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey

##Level 10 → Level 11
###Objective

Decode Base64 encoded data.

###Solution
base64 -d data.txt

###Explanation

-d decodes Base64 data into readable text.

###What I Learned

Base64 is encoding, not encryption.

Password: dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr

##Level 11 → Level 12
###Objective

Decode text encrypted with ROT13.

###Solution
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'

###Explanation

tr translates characters from one set to another.

###What I Learned

ROT13 is a simple substitution cipher.

Password for next level:7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4

##Level 12 → Level 13
###Objective
The password for the next level is stored in the file data.txt, which is a hexdump of a file that has been repeatedly compressed. For this level it may be useful to create a directory under /tmp in which you can work. Use mkdir with a hard to guess directory name. Or better, use the command “mktemp -d”. Then copy the datafile using cp, and rename it using mv (read the manpages!)


Extract the password hidden inside multiple compressed files.

###Commands Tried
xxd -r data.txt > binary
file binary

Then repeatedly:

gzip -d
bzip2 -d
tar -xf

###Debugging Steps

I had to read man pages for gzip bzip2, file, tar -xf the f there means expect a file:

tar -xf dat6

Failed because the filename was mistyped.

Corrected with:

tar -xf data6

tar: The program used to bundle multiple files into one.-x: Extracts the files (unpacks them).-f: Tells the program that the very next word (binary) is the archive file it needs to read.binary: The specific file you want to unpack

###Solution

Repeatedly identify file types using:

file <filename>

Then decompress using the correct tool until the final text file appeared.

Final password retrieved using:

cat data8

###Explanation

The file was compressed multiple times using different formats:

gzip
bzip2
tar archives
###What I Learned
READ MAN PAGES FOR ALL COMMANDS!!!
file is essential for identifying unknown formats.
Compression formats can be layered.
/tmp is useful for temporary workspaces.

The password is FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn

##Level 13 → Level 14
###Objective
The password for the next level is stored in /etc/bandit_pass/bandit14 and can only be read by user bandit14. For this level, you don’t get the next password, but you get a private SSH key that can be used to log into the next level. Look at the commands that logged you into previous bandit levels, and find out how to use the key for this level.
If you need help with this level: a hint file can be found in the home directory.
Make sure to read the error messages as they are informative.

Use an SSH private key to log into the next level.


###Commands Tried
nano sshkey.private
chmod 600 sshkey.private
ssh
man

###Solution
Copied and pasted and saved ssh private key to my local ubuntu machine in a file using nano command:
read the man page, used nano to copy and paste the private key from the previous level. chmod 600 sshkey.private
Changed permissions 
This means:
	• only my  user can read/write the key 
SSH often refuses insecure keys otherwise.
then used the following command to ssh into the next machine:

ssh -i sshkey.private bandit14@bandit.labs.overthewire.org -p 2220

###Explanation

chmod 600 restricts access to the private key.
SSH rejects insecure key permissions.

###What I Learned

How SSH key authentication works.

Password for bandit14 is: MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS

##Level 14 → Level 15
###Objective
The password for the next level can be retrieved by submitting the password of the current level to port 30000 on localhost.


Send the current password to a service running on localhost port 30000.

###Solution
echo <password> | nc 127.0.0.1 30000

###Explanation
shell (bandit14 session)
 |
 v
send text (password)
 |
 v
localhost:30000 (program)
 |
 v
returns next password

Command explained:
echo sends text.
| pipes the text into nc.
nc (netcat) connects to the local service.

###What I Learned
The nc (Netcat) command in Linux is a powerful networking utility used to read and write data across network connections using TCP or UDP protocols.
How to communicate with TCP services using netcat.

Password for bandit15 is: 8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo


##Level 15 → Level 16
###Objective
The password for the next level can be retrieved by submitting the password of the current level to port 30001 on localhost using SSL/TLS encryption.

Helpful note: Getting “DONE”, “RENEGOTIATING” or “KEYUPDATE”? Read the “CONNECTED COMMANDS” section in the manpage.

Connect to an SSL/TLS encrypted service.

###Roadblocks
Initially I assumed:

nc localhost <port>
would work like the previous level.
However, the level introduced SSL/TLS encryption.
I wasn't sure:
	• which port to use 
	• which services were running 
	• which service actually wanted the password 


###Investigation
Used:

nmap -sV --script ssl-cert -p 31000-32000 127.0.0.1
Output showed several ports:

31046 echo
31518 ssl/echo
31691 echo
31790 ssl/unknown
31960 echo
Port 31790 stood out because it responded:

Wrong! Please enter the correct current password.


###Solution

openssl s_client -connect 127.0.0.1:31790

Then submitted the current password through the SSL connection.

###Commands Learned

nmap - Port scanning.

openssl s_client - SSL/TLS client.

nmap -sV - Service detection.

--script ssl-cert - Inspect SSL services.

echo "<password>" | openssl s_client -connect localhost:30001 -quiet

###Explanation

openssl s_client creates an SSL/TLS connection to the service.

###What I Learned

TCP and SSL/TLS are different layers.
A service can run on TCP but require SSL encryption.
nmap can identify running services and SSL ports.
openssl s_client is essentially "netcat for SSL/TLS".
Enumeration is often:
Find open ports
Identify services
Determine protocol
Use the correct client

Some services require encrypted communication instead of plain TCP.

Next password: kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx

##Level 16 → Level 17
###Objective
The credentials for the next level can be retrieved by submitting the password of the current level to a port on localhost in the range 31000 to 32000. First find out which of these ports have a server listening on them. Then find out which of those speak SSL/TLS and which don’t. There is only 1 server that will give the next credentials, the others will simply send back to you whatever you send to it.

Find the correct SSL-enabled port and retrieve the password.

###Roadblocks

This one was tricky. As I forgot that ssh can sometimes be blocked in servers. Saved the private key outisde in my own local ubuntu machine in a tmp folder, ls -a to show the hidden file with the private key was created. For some reason I then navigated back to my home folder tried to ssh from there, did not work at all. I then relasied in linux where you are in the file system matters, so I navigated back into the tmp folder used the command below to ssh onto the next machine, and lo and behold it worked.

###Solution
nmap localhost -p 31000-32000

Then:

ssh -i /tmp/bandit17.key bandit17@bandit.labs.overthewire.org -p 2220

###What I Learned
Port scanning helps identify running services.
SSL services can exist on non-standard ports.
Always ensure you know where you private key is stored.

##Level 17 → Level 18
###Objective
There are 2 files in the homedirectory: passwords.old and passwords.new. The password for the next level is in passwords.new and is the only line that has been changed between passwords.old and passwords.new

Find the only changed line between two files.

###Commands Tried
head passwords.old
head passwords.new
###Debugging Steps

Initially typed:

head password.old

Failed because the filename was incorrect.

###Solution
diff passwords.new passwords.old
###Explanation

diff compares two files and highlights differences.

###What I Learned

How to compare files using diff.
Make sure to type filename correctly.

Password for next level x2gLTTjFwMOhQ8oWNbMN362QKxfRqGlO

##Level 18 → Level 19
###Objective

The password for the next level is stored in a file readme in the homedirectory. Unfortunately, someone has modified .bashrc to log you out when you log in with SSH.


Read a file despite the shell logging out immediately after login.

###Solution

ssh bandit18@bandit.labs.overthewire.org -p 2220 'cat readme'

###Explanation

Passing a command directly into SSH avoids opening an interactive shell.

###What I Learned

This level taught me that even if .bashrc logs me out during an SSH login, I can still execute commands remotely by passing the command directly into the ssh command instead of opening an interactive shell.

SSH can execute commands remotely without opening a full session.

##Level 19 → Level 20
###Objective

To gain access to the next level, you should use the setuid binary in the homedirectory. Execute it without arguments to find out how to use it. The password for this level can be found in the usual place (/etc/bandit_pass), after you have used the setuid binary.


Use a special executable to run commands as another user.

###Commands Tried
./bandit20-do cat bandit20

###Why It Failed

The executable was not in the current directory.

###Debugging Steps

Checked current location:

pwd

Moved to the correct directory:

cd /home/bandit19

###Solution
./bandit20-do cat /etc/bandit_pass/bandit20

###Explanation
./ runs a file from the current directory.
bandit20-do executes commands with bandit20 permissions.

###What I Learned
How setuid-style executables work.
Why relative paths depend on the current directory.
Password for next level: cGWpMaKXVwDUNgPAVJbWYuGHVn9zl3j8

