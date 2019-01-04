require 'line/bot'
class ApiController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    body = request.body.read
    event = client.parse_events_from(body).last
    the_undefined_method
    head :ok
  rescue => e
    message = {
      type: 'text',
      text: exception_message(e)[0...2000]
    }
    client.reply_message(event['replyToken'], message)
    head :ok
  end

  def the_undefined_method
    nil['a']
  end

  private

  def exception_message(exception)
    bc = ActiveSupport::BacktraceCleaner.new
    bc.add_filter   { |line| line.gsub(Rails.root.to_s, '') }
    bc.add_silencer { |line| line =~ /\/gems\// }
    backtrace = bc.clean(exception.backtrace)
    "#{exception.message}\n#{backtrace.join("\n")}"
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = '9c60745440d955a1434eb9e659248272'
      config.channel_token = 'UC9ZkaFaeEb57ECLvADn+v2zwIcsDqv4IPElB5SrYd610RTSakoJy02UE8kpS/KUJWBZSrvnjW1yV3CouSZ9oUPSmxck153DupUl8IoxO+zhpYV1ZlffbGxdo0u+Ou1tTc7EI7Q4KWWcbvZXtBk6HQdB04t89/1O/w1cDnyilFU='
    end
  end
end
