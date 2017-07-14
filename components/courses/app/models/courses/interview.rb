module Courses
  class Interview < ApplicationRecord
    include ApplicationHelper

    self.table_name = 'courses_interviews'

    belongs_to :mentor
    belongs_to :student, optional: true

    validates :start_at, uniqueness: { scope: :mentor_id }, presence: true
    validate  :has_interview_earlier_than_allowed_interval

    ALLOWED_INTERVAL = 30

    def has_interview_earlier_than_allowed_interval
      if Courses::Interview::HasInterviewEarlierThanAllowedInterval.new(mentor, self, ALLOWED_INTERVAL).call
        errors.add(:start_at, "should be at least #{ALLOWED_INTERVAL} minutes after your previous interview")
      end
    end

    def mentor_name
      mentor.full_name
    end

    # need to be changed after creating a Student model
    def student_name
      'Smartest student'
    end

    def title
      I18n.t 'courses_season_interviews.singular'
    end
  end
end