defmodule Tamnoon.Compiler do
  @moduledoc """
  This module provides functions for compiling (/parsing) Tamnoon HEEx components.
  """

  @doc """
  Compiles the 'root.html.heex' file into the final file that is sent to the client.
  """
  @spec build_from_root(ws_address :: String.t(), root_path :: String.t()) :: :ok | {:error, atom()}
  def build_from_root(ws_address \\ "ws://localhost:4000/ws/", root_path \\ "root.html.heex") do
    compiled_html = render_component(root_path, %{ws_address: ws_address})
    |> parse_tmnn_heex()
    File.write("tamnoon_out/app.html", compiled_html)
  end

  @doc """
  Returns the compiled HTML code of the component. Takes as arguments:
  - either a component module or a file name of a heex component file inside _lib/components_,
  - the _assigns_ for the EEx blocks in the component,
  - and a boolean for whether to parse the Tamnoon heex.
  When the function is used inside a component that gets built into the root in the `build_from_root/2`
  function, the last argument should be `false` to avoid invoking `parse_tmnn_heex/1` multiple
  times.
  Inside EEx blocks in heex components, this function can be invoked as `<%= r.(MyComponent) %>`.
  """
  @spec render_component(module() | String.t(), map(), boolean()) :: String.t()
  def render_component(component, assigns \\ %{}, parse_tmnn_heex \\ false)
  def render_component(component, assigns, true) do
    render_component(component, assigns, false)
    |> parse_tmnn_heex()
  end

  def render_component(component, assigns, false) when is_binary(component) do
    "lib/components/" <> component
    |> EEx.eval_file([r: &render_component/1, assigns: assigns])
  end

  def render_component(component, assigns, false) do
    component.heex()
    |> EEx.eval_string([r: &render_component/1, assigns: assigns])
  end

  @doc """
  Takes as an argument a string containing compiled heex for a component, and returns the
  component as plain HTML for it to be rendered on the DOM.
  """
  @spec parse_tmnn_heex(String.t()) :: String.t()
  def parse_tmnn_heex(compiled_heex) do
    Regex.replace(~r/< *\w *[^>]*> *(?:@([a-z|\d]+))?/m, compiled_heex, fn x, innerHtml ->
      attr_classes = get_component_attrs(x, innerHtml)
      |> Enum.reduce("", fn {key, attrs}, acc ->
        acc <> Enum.reduce(attrs, "", fn attr, acc ->
          if (String.starts_with?(attr, "on")) do
            acc <> " tmnnevent-" <> "#{attr}-" <> Atom.to_string(key)
          else
            acc <> " tmnn-" <> Atom.to_string(key) <> "-#{attr}"
          end
        end)
      end)
      x = Regex.replace(~r/(?<attr>[a-z|\d]+)=@(?<key>[a-z|\d]+)/m, x, "")
      x = Regex.replace(~r/>( *@[a-z|\d]+)/m, x, ">")
      IO.inspect(x)
      x = if (x =~ ~r/class="[^"]*"/ || attr_classes == "") do
        x
      else
        [a, b] = Regex.split(~r/< *\w+/, x, [parts: 2, include_captures: true, trim: true])
        a <> " class=\"\" " <> b
      end
      Regex.replace(~r/class="([^"]*)"/, x, fn _, classes ->
        "class=\"#{classes}#{attr_classes}\""
      end)

    end)
  end

  defp get_component_attrs(component, "") do
    Regex.scan(~r/(?<attr>[a-z|\d]+)=@(?<key>[a-z|\d]+)/m, component)
    |> Enum.group_by(&(String.to_atom(Enum.at(&1, 2))), &(Enum.at(&1, 1)))
  end

  defp get_component_attrs(component, innerHtml) do
    [[nil, "innerHtml", innerHtml]]
    |> Enum.concat(Regex.scan(~r/(?<attr>[a-z|\d]+)=@(?<key>[a-z|\d]+)/m, component))
    |> Enum.group_by(&(String.to_atom(Enum.at(&1, 2))), &(Enum.at(&1, 1)))
  end

end
