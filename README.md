# docker-git-pull

Keeps local git repositories up to date by continuously pulling them-

## USAGE

Set `GIT_REPO` git repository URL.  
Set `GIT_REPO_BRANCH` environment variable to the git branch, defaults to `main`.  
Set `SYNC_INTERVAL` to a delay in seconds between each pull, defaults to `30`.  
Set `GITCRYPT_SYMMETRIC_KEY` if using git-crypt.  

Mount an external directory to `/home/git/repo`. This is where the git stuff happens.
