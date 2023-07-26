require "spoom"
require "debug"

class SpoomClient
  def initialize(node, processed_source)
    @node = node
    @processed_source = processed_source
  end

  def contents
    path = File.expand_path(".") # /app/models/product.rb")

    client = Spoom::LSP::Client.new(
      Spoom::Sorbet::BIN_PATH,
      "--lsp",
      "--enable-all-experimental-lsp-features",
      "--disable-watchman",
      path:,
    )
    client.open(File.expand_path(path))

    file = Pathname(processed_source.file_path).relative_path_from(path).to_s

    res = client.type_definitions(to_uri(file), node.loc.line - 1, node.loc.column)
    uri = res.first.uri

    File.read(uri.delete_prefix("file://")).lines[res.first.range.start.line].strip
  end

  private

  attr_reader :node, :processed_source

  def to_uri(path)
    "file://" + File.expand_path(path)
  end
end
