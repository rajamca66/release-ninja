module Git
  class PullRequest
    API_FIELDS = [:id, :number, :merged_at, :body, :title, :html_url]
    JSON_FIELDS = [:id, :number, :merged_at, :title, :html_url]

    attr_accessor *API_FIELDS, :repository

    def self.from_api_response(pr, repository:, client:)
      new(client).tap do |instance|
        instance.repository = repository
        API_FIELDS.map do |field|
          instance.send("#{field}=", pr[field])
        end
      end
    end

    def initialize(client)
      @github_client = client
    end

    def owner
      repository.owner
    end

    def repo
      repository.repo
    end

    def comments
      CommentFetcher.new(owner, repo, number, body, @github_client).call
    end

    def as_json
      hash = {}

      JSON_FIELDS.each do |field|
        hash[field] = self.send(field)
      end

      hash[:owner] = owner
      hash[:repo] = repo
      hash[:comments] = comments

      hash
    end

    private

    CommentFetcher = Struct.new(:owner, :repo, :number, :body, :client) do
      def call
        comments.select{ |cp| cp.release_note? }
      end

      private

      def comments
        @comments ||= begin
          ret = client.issues.comments.list(owner, repo, number: number).map{ |c| Comment.new(c.body) }
          ret << Comment.new(body)
        end
      end
    end
  end
end
