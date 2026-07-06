# 🖥️ Bash Scripting

This section of the repository contains practical Bash scripting exercises completed as part of my DevOps learning journey.

The focus of these challenges is to develop automation skills by combining Bash scripting with Linux commands to perform common system administration tasks.

Rather than simply writing scripts that work, I aimed to understand the logic behind each solution, improve my problem-solving skills, and build reusable automation scripts.

---

# 📂 Contents

```text
bash-scripting/
│
├── README.md
├── challenge1.sh
├── challenge2.sh
├── challenge3.sh
└── challenge4.sh
```

---

# 📜 Script Overview

## Challenge 1 – Basic Arithmetic Calculator

A calculator script that:

- Prompts the user for two numbers
- Performs addition, subtraction, multiplication and division
- Prevents division by zero
- Displays the results of each operation

### Skills Practised

- User input (`read`)
- Variables
- Arithmetic expansion
- Conditional statements (`if`)
- Input validation

---

## Challenge 2 – File Operations Script

A script that automates directory and file creation.

The script:

- Creates a new directory
- Navigates into it
- Creates a text file
- Writes the current date into the file
- Displays the file contents

### Skills Practised

- Directory creation
- File creation
- Command substitution (`$(date)`)
- Output redirection
- Functions

---

## Challenge 3 – File Checker

A script that validates whether a file exists before checking its permissions.

The script:

- Prompts the user for a filename
- Checks whether the file exists
- Determines whether the file is:
  - Readable
  - Writable
  - Executable
- Displays clear permission messages

## Challenge 4 — Backup Script (Toughest one)

Script that backs up all `.txt` files from a source directory into a timestamped backup folder, with a file count summary.

The script:

- Prompts the user for a source directory
- Creates a timestamped backup directory
- Copies all `.txt` files
- Displays how many files were backed up


**Bugs I worked through:**
- Variable never assigned a value before being used in `mkdir`/`cp`
- `mkdir` and `cp` pointing at two different paths instead of one shared variable
- A bare `$(date ...)` left unattached on its own line
- Missing `$` when referencing a variable (bash treated it as literal text)
- Mismatched/unbalanced quotes breaking the script
- Piping `echo` into `wc -l` instead of piping `ls`/`find` output — always returned 1 instead of the real file count


### Skills Practised

- File test operators
- User input
- Functions
- Conditional logic
- Error handling

---

# 🛠️ Key Learnings

Throughout these challenges I developed practical experience with:

- Writing reusable functions to organise code
- Using variables and user input to make scripts dynamic
- Applying conditional statements to validate input and handle errors
- Automating file and directory operations using Linux commands
- Combining Bash features such as loops, command substitution and file test operators to build practical automation scripts

---

# 💡 Challenges I Overcame

### Challenge 1 – Division by Zero Validation

Initially I focused on performing the arithmetic before validating the input.

Through debugging I learned that validation should happen **before** carrying out an operation, preventing errors such as division by zero.

---

### Challenge 2 – Dynamic File Creation

My first solution used a hardcoded date.

I improved the script by using command substitution with `$(date)` to automatically insert the current date, making the script reusable instead of producing the same output every time.

---

### Challenge 3 – File Validation Before Permission Checks

At first I checked file permissions regardless of whether the file existed.

I learned to use an **early return** after validating the file exists, allowing the function to exit immediately if the file is missing before attempting further checks.

This introduced me to a common programming pattern used across many scripting and programming languages.

---

### Challenge 4 – Variable Scope & Path Consistency

Initially I built the backup path inline, directly inside the `mkdir` command, and used a separate reference to it in the `cp` command afterward.

Through debugging I learned that a value used in multiple places should be built **once** and stored in a single variable, then reused everywhere it's needed — otherwise commands can silently point at two different, mismatched paths.

---

# 🚀 Why Bash Matters in DevOps

Bash is one of the core scripting languages used by Linux system administrators and DevOps engineers.

Learning Bash provides the foundation for automating repetitive tasks such as:

- Creating and managing files and directories
- Validating system configuration
- Monitoring servers
- Processing log files
- Managing users and permissions
- Scheduling automated tasks
- Writing deployment and provisioning scripts

Many CI/CD pipelines, cloud deployments and infrastructure automation tools rely on Bash scripts to glue different technologies together, making Bash an essential skill for anyone pursuing a career in DevOps.

---

# 🎯 Skills Developed

- Bash scripting
- Linux command-line automation
- Variables and parameters
- Functions
- Conditional statements
- Loops
- File and directory operations
- User input
- File permission checks
- Command substitution
- Error handling
