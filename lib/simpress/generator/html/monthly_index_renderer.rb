# frozen_string_literal: true

require "simpress/paginator"
require "simpress/generator/html/index_renderer"

module Simpress
  module Generator
    module Html
      module MonthlyIndexRenderer
        def self.generate(monthly_archives)
          monthly_archives.each do |date, posts_by_monthly|
            paginator = Simpress::Paginator.builder
                                           .maxpage(Simpress::Paginator.calculate_pagesize(posts_by_monthly))
                                           .page(1)
                                           .prefix("/archives/#{date.year}/#{format('%02d', date.month)}")
                                           .build

            IndexRenderer.generate(posts_by_monthly, paginator, "#{date.year}/#{date.month}")
          end
        end
      end
    end
  end
end
