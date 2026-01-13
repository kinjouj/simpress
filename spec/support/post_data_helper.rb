# frozen_string_literal: true

module PostDataHelper
  def build_post_data(
    id,
    title: nil,
    content: nil,
    description: nil,
    date: Time.now,
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
    description ||= "Post Description #{id}"

    Simpress::Post.new(
      id: id.to_s,
      title: title,
      content: content,
      description: description,
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
