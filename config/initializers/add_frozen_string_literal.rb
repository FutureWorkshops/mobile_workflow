# frozen_string_literal: true

# Adds a `frozen_string_literal` comment to the top of files created by Rails
# generators.
#
# Taken from https://gist.github.com/thornomad/4e2f0905e2a4a6eefbc4be5772dfd4f7#gistcomment-3533276

return unless defined?(::Rails::Generators)

module RailsGeneratorFrozenStringLiteralPrepend
  RUBY_EXTENSIONS = %w[.rb .rake]

  def render
    return super unless RUBY_EXTENSIONS.include? File.extname(self.destination)
    "# frozen_string_literal: true\n\n" + super
  end
end

Thor::Actions::CreateFile.prepend RailsGeneratorFrozenStringLiteralPrepend
