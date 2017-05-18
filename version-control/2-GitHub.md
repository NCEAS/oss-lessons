GitHub
=======
	
You might also have heard of [GitHub](https://github.com). **GitHub is a company that hosts git repositories online** and provides several collaboration features (among which `forking`). GitHub fosters a great user community and has built a nice webinterface to git, also adding great visualization/rendering capacities of your data.

* **GitHub.com**: <https://github.com>
* **A user account**: <https://github.com/brunj7>
* **An organization account**: <https://github.com/nceas>
* **NCEAS GitHub instance**: <https://github.nceas.ucsb.edu/> 

## Creating a new repository

We are going to create a new repository on your GitHub account:

* Click on ![image alt text](images/image_10.png)
* Enter a descriptive name for your new repo (avoid upper case and use `-` instead of spaces)
* Choose **"Public"** (Private repositories are not free)
* Check **"Initialize this repository with a README”**
* Add a `.gitignore` file (optional). As the name suggest, the gitignore file is used to specify the file format that git should to track. GitHub offer prewritten gitignore files for commodity
* Add a license file (optional)

<img style="align: left;width: 35px;" src=images/tip.png /> Here is a website to look for more prewritten`.gitignore` files: <https://github.com/github/gitignore>


## Adding an existing local repository to GitHub

* Same as "Creating a new repository", except
* Do **not** create a readme file nor .gitignore file
* On your local terminal:

    * Go inside your local repository with the terminal/shell
    * Add the remote: `git remote add origin <URL to your repo>`
    * Do the first push: `git push -u origin master`
    * Enter your username and password




## Collaborating with git and GitHub

### Collaborating through Forking, aka the GitHub workflow

A **fork** is a **copy of a repository** that will be stored under your user account. Forking a repository allows you to freely experiment with changes without affecting the original project.

Most commonly, forks are used to either propose changes to someone else's project or to use someone else's project as a starting point for your own idea.

When you are satisified with your work, you can intiate a ***Pull Request*** to initiate discussion about your modifications. Your commit hisotry allows the original repository administrators to see exactly what changes would be merged if they accept your request.  

By using GitHub's `@mention` syntax in your Pull Request message, you can ask for feedback from specific people or teams.

### Collaboratng through write access

When you collaborate closely and actively with colleagues, you do not want ncessarily to have to review all their changes through pull requests. You can then give them write access (`git push`) to your repository to allow them to directly edit and contribute to its content.

#### Adding collaborators to a repository 

* Click on the repository
* On the right panel, click ![image alt text](images/image_11.png)
* On the left pane, click Collaborators and enter the usernames you want to add![collaborators](images/github_collaborators.png) 

#### Adding a team to a repository (organiztion only)

* Click on the repository
* On the right panel, click ![image alt text](images/image_11.png)
* On the left pane, click Collaborators & teams ![image alt text](images/image_12.png)
* Select your team ![image alt text](images/image_13.png)
* Select the appropriate Permission level. We recommend Write or Admin. Admin allows people to also add collaborators. 

![image alt text](images/image_14.png)


# References

- GitHub:
 - guides on how to use GitHub: [https://guides.github.com/](https://guides.github.com/)
 - GitHub from RStudio: [http://r-pkgs.had.co.nz/git.html#git-pull](http://r-pkgs.had.co.nz/git.html#git-pull)
- Forking:
 - [https://help.github.com/articles/fork-a-repo/](https://help.github.com/articles/fork-a-repo/)
 - [https://guides.github.com/activities/forking/](https://guides.github.com/activities/forking/)