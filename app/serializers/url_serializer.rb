class UrlSerializer < ActiveModel::Serializer
  attributes :id, :url, :original_url, :views, :short_url

  def short_url
    [ Rails.application.credentials.dig(:host), object.url].join('/')
  end
end
