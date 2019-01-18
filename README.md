# docker-git-pull

Keeps local git repositories up to date by continuously pulling them-

## USAGE

Set `URL` git repository URL.  
Set `BRANCH` environment variable to the git branch, defaults to `master`.
Set `SLEEP` to a delay in seconds between each pull, defaults to `30`.

Mount an external directory to `/repo`. This is where the git stuff happens.