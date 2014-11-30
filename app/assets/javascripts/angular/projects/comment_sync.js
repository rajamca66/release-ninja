(function() {
  Ctrl = function($scope, project, Repository) {
    var self = this;

    self.project = project;

    self.repositories = _(project.repositories).map(function(repository) {
      return new Repository(repository, project.id);
    }).value();

    self.severityLevels = {
      major: "Major",
      minor: "Minor",
      fix: "Fix"
    };
  };

  RepositoryFactory = function(Restangular, PullRequest) {
    return function Repository(repository, projectID) {
      var self = this;
      var currentPage = 1;

      self.name = repository.full_name;
      self.pullRequests = [];
      self.loading = false;
      self.loadNextPage = loadNextPage;

      loadNextPage();

      function loadNextPage() {
        self.loading = true;
        Restangular.all("github/pull_requests")
          .customGETLIST(null, { project_id: projectID, repository_id: repository.id, page: currentPage++, size: 5 })
          .then(function(pull_requests) {
            _(pull_requests).each(function(pr) {
              self.pullRequests.push(new PullRequest(pr, projectID));
            });
          }).finally(function() {
            self.loading = false;
          });
      }
    };
  };

  PullRequestFactory = function(Comment) {
    return function PullRequest(pullRequest, projectID) {
      var self = this;

      self.comments = _(pullRequest.comments).map(function(comment) {
        return new Comment(comment, pullRequest.id, projectID, onNoteCreate);
      }).value();

      self.merged_at = new Date(pullRequest.merged_at);
      self.title = pullRequest.title;
      self.url = pullRequest.html_url;
      self.has_note = pullRequest.has_note;

      function onNoteCreate() {
        self.has_note = true;
      }
    };
  };

  CommentFactory = function(Restangular) {
    return function Comment(comment, pullRequestID, projectID, onNoteCreate) {
      var self = this;

      self.level = comment.type;
      self.title = comment.title;
      self.markdown_body = comment.body;

      self.convertToNote = function() {
        var data = {
          level: self.level,
          title: self.title,
          markdown_body: self.markdown_body,
          converted_pull_request_id: pullRequestID
        };
        Restangular.one("projects", projectID).all("notes").post(data).then(function(note) {
          onNoteCreate(note);
        });
      };
    };
  };

  Ctrl.$inject = ["$scope", "project", "Repository"];
  RepositoryFactory.$inject = ["Restangular", "PullRequest"];
  PullRequestFactory.$inject = ["Comment"];
  CommentFactory.$inject = ["Restangular"];

  angular.module("projects").controller("CommentSyncController", Ctrl)
                            .factory('Repository', RepositoryFactory)
                            .factory('PullRequest', PullRequestFactory)
                            .factory('Comment', CommentFactory);
})();
