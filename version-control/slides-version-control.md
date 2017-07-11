% Version Control
% Julien Brun and Mark Schildhauer, NCEAS, UCSB
% OSS 2017


## Why do I need that again?

<p align="center">
  <img style="width: 550px;" src=images/phd_comics_final.png />
</p>

## Why do I need that again?

<br>

### => Version Control is very useful to keep track of changes you or your collaborators made to your scripts.


## Git and GitHub

<br>

<img style="align: left;width: 300px;" src="images/git_icon.png">

<br>
Git is a *free* and *open source* distributed *version control system*. Git allows you to take snapshots of your files, creating an history of versions that you can navigate.
<br>

. . .

<img style="algn: right;width: 350px;" src="images/GitHub_logo.png">


**GitHub is a company that hosts git repositories online** and provides several collaboration features (among which `fork`). 

GitHub fosters a great user community and has built a nice graphical interface to git, adding great visualization capacities of your data.


## What we want to avoid

<br>
<p align="center">
  <img style="width: 300px;" src="images/git_xkcd.png">
</p>


*xkcd - git*

## <img style="align: middle;width: 300px;" src="images/git_icon.png"> 

### What is git

- Git is free and open source versioning system
- Git tracks changes per lines
- Git stores snapshot of your files and create a history of changes
- Git is distributed
- Git has integrity

. . .

### What git is not

- Git is not a backup per se
- Git is not GitHub (or more exactly: GitHub is not Git)
- Git is not good at storing large data (by default)

## Repository

A repository is simply a directory/folder in which you have enabled git to track its content (files and subfolders). 


## git workflow

<img style="float: right;width: 300px;" src="images/git_workflow_general.png">

1. You modify files in your working directory and save them as usual

2. You **add** snapshots of your changes files to your staging area.

3. You do a **commit**, which takes the files as they are in the staging area and stores them as snapshots permanently to your Git directory.

**And repeat!!**


## git commit history

<br>
<p align="center">
  <img style="width: 300px;" src="images/version-graph_mattJones.png">
</p>

