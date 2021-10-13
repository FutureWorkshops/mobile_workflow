# frozen_string_literal: true

module MobileWorkflow
  class ApplicationJob < ActiveJob::Base
    include Rollbar::ActiveJob
  end
end
