module MobileWorkflow
  module Displayable
    def self.included(base)
      base.extend(Steps::Form)
    end

    include Steps::List
    include Steps::Map
    include Steps::PieChart
    include Steps::Question
    include Steps::Stack
    include Steps::StyledContent::Grid
    include Steps::StyledContent::Stack

    BUTTON_STYLES = [:primary, :outline, :danger, :textOnly]
    ON_SUCCESS_OPTIONS = [:none, :reload, :backward, :forward]
    
    private
    def validate_on_success!(on_success)
      raise 'Unknown on_success action' unless ON_SUCCESS_OPTIONS.include?(on_success)
    end
    
    def validate_button_style!(style)
      raise 'Unknown style' unless BUTTON_STYLES.include?(style)      
    end

    def camelcase_converter(string, first_letter: :upper)
      string = string.split("_").map(&:capitalize).join
      return string unless first_letter == :lower

      string[0].downcase + string[1..-1]
    end
  end
end