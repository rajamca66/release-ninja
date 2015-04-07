# The Release Ninja

Provide your product manager, internal stakeholders, and customers with real-time release notes from your Github based project. By seamlessly integrating with Github, The Release Ninja is able to provide a format for "release notes" that are synced, edited, and finally published.

## Getting Started
[[Heroku placeholder]]

## 0 to Tests Passing

1. `bundle install`
2. `cp .template.env .env`
3. Obtain your Github Client ID and Secret from https://github.com/settings/applications. Place these in the .env file in the correct place.
4. Create a new Github Personal Access Token with [repo, write_repo_hook]
5. `cp spec/fixtures/your_repos.template.yaml spec/fixtures/your_repos.private.yaml`
6. Enter in some repos that you have both private / public / organizationally. This will allow for the RepositoryList spec to come out of it's pending state. These private files should not go in VCS.
7. `rspec` and your specs pass!...hopefully

## License

This project is provided under the MIT License, see LICENSE for a copy.

## In Due Time

* [ ] Emails for a user are customizable
* [ ] Releases are in an rss feed
* [X] Releases are in beautiful 1 page format
* [ ] Reviewers are in groups and groups can be notified in the workflow
* [ ] Workflow editor that triggers on different events
* [ ] UI for project settings is more intuitive
