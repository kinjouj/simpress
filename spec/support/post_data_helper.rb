# frozen_string_literal: true

require "simpress/model/post"

module PostDataHelper
  def build_post_data(
    id,
    title: nil,
    content: nil,
    date: DateTime.now,
    permalink: nil,
    toc: [],
    categories: [],
    cover: "/images/no_image.png",
    published: true,
    layout: :post
  )
    title ||= "Post #{id}"
    content ||= "Post #{id}"
    permalink ||= "/post#{id}.html"

    Simpress::Model::Post.new(
      id: id.to_s,
      title: title,
      content: content,
      date: date,
      permalink: permalink,
      categories: categories,
      toc: toc,
      cover: cover,
      published: published,
      layout: layout
    )
  end
end
