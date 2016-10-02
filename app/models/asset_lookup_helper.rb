class AssetLookupHelper
  AssetNotFound = Class.new(StandardError)

  def self.current
    @current ||= begin
      json = JSON.parse(File.read(Rails.root.join("config", "asset_manifest.json")))
      new(json)
    end
  end

  attr_reader :manifest

  def initialize(manifest)
    @manifest = manifest
  end

  def asset_for(path)
    lookup_path = if path.starts_with?("/")
      path[1..-1]
    else
      path
    end

    wrap_result(manifest[lookup_path]) || (raise AssetNotFound.new("#{lookup_path} is not found in the manifest #{manifest}"))
  end

  def wrap_result(path)
    return unless path.present?
    "/#{path}"
  end
end
