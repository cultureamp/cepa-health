Rails.application.routes.draw do
  mount CepaHealth::Engine => "/healthy(.:format)"
end
