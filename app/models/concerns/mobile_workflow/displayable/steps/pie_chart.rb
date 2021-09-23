module MobileWorkflow
  module Displayable
    module Steps
      module PieChart
        def mw_pie_chart_item(id: self.id, label:, value:)
          {id: id, label: label, value: value}.compact
        end
      end
    end
  end
end