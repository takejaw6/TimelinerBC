class StatusController < ApplicationController
  before_filter :authenticate_user!
  def reload
    Status.destroy_all

    if user_signed_in?
      @providers = current_user.auths.pluck(:provider)
    end

    if @providers.include?('twitter')
      twitter = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['TWITTER_KEY']
        config.consumer_secret = ENV['TWITTER_SECRET']
        config.access_token = current_user.auths.find_by_provider("twitter").token
        config.access_token_secret = current_user.auths.find_by_provider("twitter").secret
      end
      @twitter = twitter.home_timeline({count:20})


      @twitter.each do |t|
        unique_id = t.id.to_s
        datetime = t.created_at.in_time_zone('Tokyo')
        content = t.text
        if t.media?
          contentimg = t.media.first.media_url
        else
          contentimg = nil
        end
        bywhom = t.user.name
        bywhomimg = t.user.profile_image_url
        user_id = current_user.id
        provider = 'Twitter'
        @user = current_user
        @status = @user.statuses.new(unique_id:unique_id, datetime: datetime, provider:provider, content: content,
                             contentimg: contentimg, bywhom: bywhom, bywhomimg: bywhomimg,
                             user_id: user_id)
        @status.save
      end
    end

    if @providers.include?('instagram')
      Instagram.configure do |config|
        config.client_id = ENV['INSTAGRAM_KEY']
        config.client_secret = ENV['TWITTER_SECRET']
      end

      insta = Instagram.client(:access_token => current_user.auths.find_by_provider("instagram").token)

      @insta = insta.user_media_feed

      @insta.each do |i|
        unique_id = i.id
        datetime = Time.at(i.created_time.to_i).in_time_zone('Tokyo')
        if i.caption != nil
          content = i.caption.text
        end
        contentimg = i.images.standard_resolution.url
        bywhom = i.user.full_name
        bywhomimg = i.user.profile_picture
        user_id = current_user.id
        provider = 'instagram'
        @user = current_user
        @status = @user.statuses.new(unique_id:unique_id, datetime: datetime, provider:provider, content: content,
                             contentimg: contentimg, bywhom: bywhom, bywhomimg: bywhomimg,
                             user_id: user_id)
        @status.save
      end
    end

    redirect_to feed_path

  end

  def index
    @user = current_user
    @unsorted = @user.statuses.all
    @sorted = @unsorted.order(:datetime).reverse
  end

  def create
  end
end
