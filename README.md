# In Due Time

Release (Name, Notes)
Note (Title, Level [major, minor, fix], markdown_body, html_preview)

Release has many notes and release are customer facing
Notes themselves aren't customer facing unless in release

Releases are in an rss feed
Releases are in beautiful 1 page format

Tag by headlines that indicate severity (# Bug Fix, # New Feature, # Major Feature)



How to get comments on a PR:

pulls = github_client.pulls.list(r.user, r.repo, state: 'closed')
pull.merged_at will be set to a date if merged

pull.body.body to get the pull request body
comments = github_client.issues.comments.list("User", "repo", number: pull.number)
