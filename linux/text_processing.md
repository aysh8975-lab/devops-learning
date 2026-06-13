# Text Processing

## grep

Purpose: Search for matching text.

### Examples

grep "error" /var/log/syslog

Searches for lines containing "error".

grep -i "failed" /var/log/auth.log

Case-insensitive search.

### What I learned

- grep filters lines.
- -i ignores case.
- grep is often combined with pipes.

## awk

Purpose: Work with columns (fields) of text.

### Example

awk -F: '$7 == "/bin/bash" {print $1}' /etc/passwd

### Breakdown

-F:
- Use : as the field separator.

$7
- Shell field.

$1
- Username field.

### What I learned

Think of awk like working with spreadsheet columns.

## sed

Purpose: Modify text streams.

### Example

sed 's/old/new/g' file.txt

Replaces all occurrences of "old" with "new".

### What I learned

sed is useful for automated text editing.

## Pipes

Purpose: Connect commands together.

### Example

grep "error" logfile | wc -l

### Flow

Input
→ grep filters lines
→ wc counts them

### What I learned

Linux tools become powerful when chained together.

# Assignment Challenge

Command:

awk -F: '$7 == "/bin/bash" {print $1}' /etc/passwd

Output:

root

Explanation:

- /etc/passwd is colon-separated.
- Field 1 is the username.
- Field 7 is the login shell.
- The command prints usernames whose shell is /bin/bash.
