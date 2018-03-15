require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params, :rendered

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @rendered = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @rendered
    # @rendered = true

    # raise "Cannot double render!!" if @rendered
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Cannot double render!" if already_built_response?

    res.header['location'] = url
    res.status = 302


    @rendered = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Cannot double render!" if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)
    @rendered = true


  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    content = ERB.new("<%=template_name%>").result(binding)

    render_content(content, String)

    # a = ERB.new( '<%= contents  %>'  )
    # a = ERB.new('<%= template_name.to_s %>').result(binding)



    # @res.write(a.result)
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
