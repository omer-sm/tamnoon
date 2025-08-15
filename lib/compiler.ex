defmodule Tamnoon.Compiler do
  @moduledoc """
  This module provides functions for compiling (/parsing) Tamnoon HEEx components.
  """

  @doc """
  Compiles the provided component into the final file that is sent to the client.
  """
  @spec build_from_root(root :: String.t() | module()) :: :ok | {:error, atom()}
  def build_from_root(root \\ Tamnoon.Components.Root) do
    compiled_html =
      render_component(root)
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

  Inside EEx blocks in heex components, this function can be invoked as `<%= r.([args..]) %>`.
  See `render_component_dyn/1`.
  """
  @spec render_component(module() | String.t(), map(), boolean()) :: String.t()
  def render_component(component, assigns \\ %{}, parse_tmnn_heex \\ false)

  def render_component(component, assigns, true) do
    render_component(component, assigns, false)
    |> parse_tmnn_heex()
  end

  def render_component(component, assigns, false) when is_binary(component) do
    ("lib/components/" <> component)
    |> EEx.eval_file(r: &render_component_dyn/1, h: &escape_html/1, assigns: assigns)
  end

  def render_component(component, assigns, false) do
    component.heex()
    |> EEx.eval_string(r: &render_component_dyn/1, h: &escape_html/1, assigns: assigns)
  end

  @doc """
  Utility function passed to EEx blocks in components. Calls `render_component/3` with the
  elements in the list as the arguments. When passing it only the first argument, it can be
  passed directly without putting it in a list.
  See `render_component/3` for more info.
  """
  @spec render_component_dyn(args :: list() | module() | String.t()) :: String.t()
  def render_component_dyn(component) when not is_list(component), do: render_component(component)
  def render_component_dyn([component]), do: render_component(component)
  def render_component_dyn([component, assigns]), do: render_component(component, assigns)

  def render_component_dyn([component, assigns, parse_tmnn_heex]),
    do: render_component(component, assigns, parse_tmnn_heex)

  @doc """
  Takes as an argument a string containing compiled heex for a component, and returns the
  component as plain HTML for it to be rendered on the DOM.
  """
  @spec parse_tmnn_heex(String.t()) :: String.t()
  def parse_tmnn_heex(compiled_heex) do
    Regex.replace(
      ~r/< *\w *[^>]*> *(?:@([-_a-z\d]+))?/m,
      compiled_heex,
      fn x, inner_value ->
        attr_classes =
          get_component_attrs(x, inner_value)
          |> Enum.reduce("", fn {key, attrs}, acc ->
            acc <>
              Enum.reduce(attrs, "", fn attr, acc ->
                if String.starts_with?(attr, "on") do
                  acc <> " tmnnevent-" <> "#{attr}-" <> key
                else
                  acc <> " tmnn-" <> key <> "-#{attr}"
                end
              end)
          end)

        x = Regex.replace(~r/(?<attr>[-a-z\d]+)=@(?<key>[-_a-z\d]+)/m, x, "")
        x = Regex.replace(~r/>( *@[-_a-z\d]+)/m, x, ">")

        x =
          if x =~ ~r/class="[^"]*"/ || attr_classes == "" do
            x
          else
            [a, b] = Regex.split(~r/< *\w+/, x, parts: 2, include_captures: true, trim: true)
            a <> " class=\"\" " <> b
          end

        Regex.replace(~r/class="([^"]*)"/, x, fn _, classes ->
          "class=\"#{classes}#{attr_classes}\""
        end)
      end
    )
  end

  defp get_component_attrs(component, "") do
    Regex.scan(~r/(?<attr>[-a-z\d]+)=@(?<key>[-_a-z\d]+)/m, component)
    |> Enum.group_by(&Enum.at(&1, 2), &Enum.at(&1, 1))
  end

  defp get_component_attrs(component, inner_value) do
    if String.starts_with?(inner_value, "raw-") do
      [[nil, "innerHtml", String.slice(inner_value, 4..-1//1)]]
    else
      [[nil, "innerText", inner_value]]
    end
    |> Enum.concat(Regex.scan(~r/(?<attr>[-a-z\d]+)=@(?<key>[_a-z\d]+)/m, component))
    |> Enum.group_by(&Enum.at(&1, 2), &Enum.at(&1, 1))
  end

  @escapes %{
    "<" => "&lt;",
    ">" => "&gt;",
    "&" => "&amp;",
    "\"" => "&quot;",
    "'" => "&#39;"
  }

  @doc """
  Escapes the content so it is not rendered as HTML. Available as `<%= h.(content) %>`
  inside components.
  """
  @spec escape_html(String.t()) :: String.t()
  def escape_html(content) do
    String.replace(content, ["<", ">", "&", "\"", "'"], &Map.get(@escapes, &1))
  end
end
