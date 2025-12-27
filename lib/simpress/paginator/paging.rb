# frozen_string_literal: true

module Simpress
  module Paginator
    class Paging
      def self.paginate
        Simpress::Config.instance.paginate || 10
      end

      def self.calculate_pagesize(array)
        array.size.quo(paginate).ceil
      end
    end
  end
end
