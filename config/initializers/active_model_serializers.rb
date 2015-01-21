ActiveModel::Serializer.root = false
ActiveModel::ArraySerializer.root = false

module RailsApiSerializationPatch
  def _render_with_renderer_json(json, options)
    serializer = build_json_serializer(json, options)

    if serializer
      super(serializer, options)
    else
      super(json, options)
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  include RailsApiSerializationPatch
end
