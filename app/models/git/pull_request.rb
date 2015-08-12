module Git
  class PullRequest
    API_FIELDS = [:id, :number, :merged_at, :body, :title, :html_url, :state, :created_at, :updated_at]
    JSON_FIELDS = [:id, :number, :merged_at, :title, :html_url, :state]

    attr_accessor *API_FIELDS, :repository, :has_note

    def self.from_api_response(pr, repository:, client:)
      new(client, raw: pr).tap do |instance|
        instance.repository = repository
        API_FIELDS.map do |field|
          instance.send("#{field}=", pr[field])
        end
      end
    end

    def initialize(client, raw: nil)
      @github_client = client
      @raw = raw
    end

    def user_nickname
      @raw[:user][:login] if @raw
    end

    def comments
      CommentFetcher.new(repository, number, body, @github_client).call
    end

    def as_json
      hash = {}

      JSON_FIELDS.each do |field|
        hash[field] = self.send(field)
      end

      hash[:owner] = repository.owner
      hash[:repo] = repository.repo
      hash[:comments] = comments
      hash[:has_note] = has_note

      hash
    end

    private

    CommentFetcher = Struct.new(:repo, :number, :body, :client) do
      def call
        comments.select{ |cp| cp.release_note? }
      end

      private

      def comments
        @comments ||= begin
          ret = client.issue_comments(repo.full_name, number).map{ |c| Comment.new(c.body) }
          ret << Comment.new(body)
        end
      end
    end
  end
end
