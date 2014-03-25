# FacebookPages

A gem to easily query Facebook Pages Insights. To make it work you need to already have an access token

## Installation

Add this line to your application's Gemfile:

    gem 'facebook_pages'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install facebook_pages

## Usage
    require 'facebook_pages'

    token = '123456'
    page_id = '12345'

    api = FacebookPages::FacebookAPI.new token
    my_page = FacebookPages::FacebookPage.new page_id,api

    likes = my_page.likes

    posts = my_page.feed.posts
    fan_posts = my_page.feed.fan_posts
    admin_posts = my_page.feed.admin_posts

    post = posts.first
    post_shares = post.shares
    post_likes_count = post.likes.count
    post_comments_array = post.comments

    page_daily_insights = my_page.insights.daily_insights
    page_weekly_insights = my_page.insights.weekly_insights
    page_lifetime_insights = my_page.insights.lifetime_insights


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
