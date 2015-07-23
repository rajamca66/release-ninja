# The Release Ninja

Provide your product manager, internal stakeholders, and customers with real-time release notes from your Github based project.
By seamlessly integrating with Github, The Release Ninja is able to provide a format for "release notes" that are synced, edited,
and finally published.

## Getting Started (via Heroku)
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/SalesLoft/release-ninja)

Keeping Heroku up to date is a bit more involved than clicking a button. If you clone this repo (origin), add your heroku git repo as a
remote (called production), then you can run

`git pull origin master && git push production master --force && heroku run rake db:migrate`

then it should keep it up to date! This is only needed if we added a cool feature that you want.

## 0 to Tests Passing

1. `bundle install`
2. `rake db:setup`
3. `cp .template.env .env`
4. Obtain your Github Client ID and Secret from https://github.com/settings/developers > `Register new application`.
   Place these in the .env file in the correct place. The settings should look like the github settings at the bottom of this document.
5. Create a new Github Personal Access Token with [repo, write_repo_hook] and enter this into the .env you created.
6. Create a Google API Application and copy your id and secret to your .env. The settings are at the bottom of this document.
7. `cp spec/fixtures/your_repos.template.yaml spec/fixtures/your_repos.private.yaml`
8. Enter in some repos that you have both private / public / organizationally in `spec/fixtures/your_repos.private.yaml`.
   This will allow for the RepositoryList spec to come out of it's pending state. These private files should not go in VCS.
9. `rspec` and your specs pass!...hopefully

## License

This project is provided under the MIT License, see LICENSE for a copy.

## In Due Time

* [X] Emails for a user are customizable
* [X] Releases are in an rss feed
* [X] Releases are in beautiful 1 page format
* [ ] Reviewers are in groups and groups can be notified in the workflow
* [ ] Workflow editor that triggers on different events
* [ ] UI for project settings is more intuitive

## Github Settings - Local
![image](https://cloud.githubusercontent.com/assets/1231659/7026641/f94a29e8-dd18-11e4-846f-5a6339e4dcc5.png)

## Github Settings - Production
![image](https://cloud.githubusercontent.com/assets/1231659/7026660/1091f6b2-dd19-11e4-8b5b-3dee9dae3d70.png)

Your production URL will obviously be different than mine.

## Google API Settings - Local & Production
You can use the same API settings for local and production, but I recommend having 2 separate applications so you can easily cycle keys.
Create a new project at console.developers.google.com > APIs & auth > credentials > `Create new Client ID`
and update your settings to look like this (local & production merged)

![image](https://cloud.githubusercontent.com/assets/503436/8713837/36bf92b0-2b3c-11e5-9b24-319e5a81938f.png)
