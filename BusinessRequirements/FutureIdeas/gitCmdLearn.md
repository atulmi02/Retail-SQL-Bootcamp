## Add Branch and add to github
1. Check your current branch
   - git branch
2. Create a new branch 
  - git branch newBranchName
  - This creates the branch but does not switch to it.
3. Create and switch in one command
  - git switch -c newBranchName 
4. Verify
  - git branch
5. Push the branch to GitHub
  - git push -u origin newBranchName
  - git push
6. Switch between branches
  - Go back to main:
    - git switch main
  - Return to your feature branch:
    - git switch newBranchName
7. See all branches
  - Local:
    - git branch
  - Local + remote branches:
    - git branch -a
8. Merge into main (when the feature is complete)
  - git switch main
  - git pull origin main
  - git merge newBranchName
  - git push origin main
9. Delete the branch (optional, after merging)
  - Delete the local branch:
    - git branch -d newBranchName
  - Delete the remote branch:
    - git push origin --delete newBranchName

---

## Ignore folder in gitignore

- add folder name to gitignore like
  - tempWork/

- If the folder has already been committed to Git, adding it to .gitignore is not enough. Git will continue tracking it.
- You must remove it from Git's index while keeping it on your computer:
  - git rm -r --cached tempWork
- Then commit the change:
  - git commit -m "Stop tracking tempWork folder"
- And push:
  - git push


---

git status - to fetch status all files for modified -M, new files -U, or Deleted
git add . - add all files to repository
git commit -m - commits all files to repo "-m message for commit"
git push origin main - push repos for same version on origin and main
git branch - get the current working branch
git switch -c "new branch name" - create and switch to new branch
git switch "branch name" - switch to branch
git branch -a - shows list of all branch from local + repos

When something is complete and polished
- git switch main
- update it
  - git pull origin main
- Merge your work
  - git merge Retail_Sql_Working
- Push
  - git push origin main