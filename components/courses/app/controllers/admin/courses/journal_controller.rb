module Admin
  module Courses
    class JournalController < ::Admin::Courses::BaseController
      helper_method :students, :lectures, :total_hash

      breadcrumps do
        add :journal_breadcrumb
      end

      private

      def journal_breadcrumb
       add_breadcrumb 'courses.journal.singular',
        path: admin_courses_season_journal_path(current_season)
      end

      def students
        @students ||= ::Courses::Student.attending
          .includes(:user)
          .includes(:progresses)
          .where(season_id: current_season.id)
      end

      def lectures
        @lectures ||= current_season.lectures
      end

      def total_hash
        @total_hash ||= ::Courses::Student::TotalHash
          .call(students, params[:sort_by], params[:lecture])
      end
    end
  end
end