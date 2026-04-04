# Plugin: RecentPosts


@postsから先頭から5件だけを切り出したのを@recent_postsとして利用できる。


```erb
<% @recent_posts.each |post| %>
<%= post.title %>
<% end %>
```
