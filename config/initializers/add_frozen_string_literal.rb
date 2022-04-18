# frozen_string_literal: true

# Adds a `frozen_string_literal` comment to the top of files created by Rails generators.
# Taken from https://gist.github.com/thornomad/4e2f0905e2a4a6eefbc4be5772dfd4f7#gistcomment-3533276
#
# Warning! Doorkeeper auto generated files already include `frozen_string_literal`, so it will be duplicated.

return unless defined?(::Rails::Generators)

module RailsGeneratorFrozenStringLiteralPrepend
  RUBY_EXTENSIONS = %w[.rb .rake].freeze

  def render
    return super unless RUBY_EXTENSIONS.include? File.extname(destination)

    "# frozen_string_literal: true\n\n#{super}"
  end
end

Thor::Actions::CreateFile.prepend RailsGeneratorFrozenStringLiteralPrepend
